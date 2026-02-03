/* ==============================================================================
 SCRIPT: 07_view_audit_loss_root_cause.sql
 AUTHOR: [Tu Nombre / Your Name]
 
 OBJECTIVE: 
 Final Audit of Unprofitable Customers with Financial Impact Analysis.
 OBJETIVO: 
 Auditoría Final de Clientes No Rentables con Análisis de Impacto Financiero.
 
 ------------------------------------------------------------------------------
 LOGIC STRUCTURE / ESTRUCTURA LÓGICA:
 ------------------------------------------------------------------------------
 We categorize loss-making customers into 4 prioritized buckets based on Root Cause:
 Clasificamos a los clientes con pérdidas en 4 cubos priorizados según la Causa Raíz:

 1. RED LIST (Fraud/Abuse) / LISTA ROJA (Fraude/Abuso):
    - Criteria: At least 3 orders AND >50% are 'SUSPECTED_FRAUD'.
    - Action: Block user immediately.
    - Criterio: Al menos 3 pedidos Y >50% son 'SOSPECHA_FRAUDE'.
    - Acción: Bloquear usuario inmediatamente.

 2. POLICY CHANGE (Returns) / CAMBIO POLÍTICA (Devoluciones):
    - Criteria: At least 3 orders AND >50% are Returns (Shipped but Canceled).
    - Action: Stop free shipping/returns. Apply Return Fee.
    - Criterio: Al menos 3 pedidos Y >50% son Devoluciones (Enviado pero Cancelado).
    - Acción: Eliminar envíos gratis. Cobrar tasa de devolución.

 3. STRATEGY (Marketing) / ESTRATEGIA (Marketing):
    - Criteria: Profitable structure (Sales - Cost > 0), but negative profit due to discounts.
    - Action: Eliminate coupons. The customer is healthy, the discount is toxic.
    - Criterio: Estructura rentable, pero beneficio negativo por descuentos.
    - Acción: Eliminar cupones. El cliente es sano, el descuento es tóxico.

 4. STRUCTURAL (Operations) / ESTRUCTURAL (Operaciones):
    - Criteria: Unprofitable even without discounts.
    - Action: Structure is unsustainable. Apply Minimum Order Quantity (MOQ).
    - Criterio: No rentable incluso sin descuentos.
    - Acción: Estructura insostenible. Aplicar Pedido Mínimo (MOQ).
 ==============================================================================
*/

DROP VIEW IF EXISTS vw_loss_drivers;

CREATE VIEW vw_loss_drivers AS

-- CTE 1: Analyze individual customer behavior / Analizar comportamiento individual del cliente
WITH customer_behavior AS (
    SELECT 
        f.customer_id,
        COUNT(f.order_id) AS total_orders,
        
        -- A) Fraud Count (Flagged by System) / Conteo de Fraude (Marcado por Sistema)
        COUNT(CASE WHEN f.order_status = 'SUSPECTED_FRAUD' THEN 1 END) AS fraud_orders,
        
        -- B) Return Count (Order Canceled but Item was Shipped) 
        -- Conteo Devoluciones (Orden Cancelada pero el ítem fue Enviado, si el envío sale ya estamos teniendo gastos)
        COUNT(CASE 
            WHEN f.order_status = 'CANCELED' AND f.delivery_status <> 'Shipping canceled' 
            THEN 1 END
        ) AS return_orders,
        
        SUM(f.sales) AS total_sales,
        SUM(f.real_profit) AS current_profit, -- This is currently negative / Esto es negativo actualmente
        SUM(f.discount) AS total_discount,
        
        -- C) What-If Analysis: Profit if we hadn't given a discount
        -- Análisis What-If: Beneficio si no hubiéramos dado descuento
        (SUM(f.real_profit) + SUM(f.discount)) AS profit_without_discount
        
    FROM fact_order_lines f
    JOIN dm_customer_rfm c ON f.customer_id = c.customer_id
    WHERE c.total_profit < 0 -- Focus only on loss-making customers / Solo clientes con pérdidas
    GROUP BY 1
),

-- CTE 2: Apply Business Logic Rules / Aplicar Reglas de Negocio
grouped_causes AS (
    SELECT 
        CASE 
            -- Rule 1: Fraud (Threshold: >=3 orders to avoid false positives on new users)
            -- Regla 1: Fraude (Umbral: >=3 pedidos para evitar falsos positivos en nuevos usuarios)
            WHEN total_orders >= 3 AND (fraud_orders::numeric / NULLIF(total_orders, 0)::numeric) >= 0.50 
                THEN 'RED LIST: Suspected Fraud (Block User)'
            
            -- Rule 2: Excessive Returns (Threshold: >=3 orders AND >50% return rate)
            -- Regla 2: Devoluciones Excesivas (Umbral: >=3 pedidos Y >50% tasa devolución)
            WHEN total_orders >= 3 AND (return_orders::numeric / NULLIF(total_orders, 0)::numeric) >= 0.50 
                THEN 'POLICY CHANGE: Excessive Returns (Apply Fee)'
            
            -- Rule 3: Bad Marketing Strategy (Profitable without discount)
            -- Regla 3: Mala Estrategia Marketing (Rentable sin descuento)
            WHEN profit_without_discount > 0 
                THEN 'STRATEGY: Bad Discounting (Marketing)'
            
            -- Rule 4: Structural Issue (Unprofitable regardless of discount)
            -- Regla 4: Problema Estructural (No rentable independientemente del descuento)
            ELSE 'STRUCTURAL: Logistics/Product Costs (Operations)'
        END AS root_cause,
        
        COUNT(customer_id) AS customer_count,
        SUM(current_profit) AS total_loss, 
        SUM(total_discount) AS discount_wasted
    FROM customer_behavior
    GROUP BY 1
)

-- FINAL SELECT: Calculate % Impact / Selección Final: Calcular Impacto %
SELECT 
    root_cause,
    customer_count,
    total_loss,
    discount_wasted,
    
    -- Calculation: (Segment Loss / Total Loss) * 100
    -- Note: Cast to numeric is required for ROUND function in PostgreSQL
    -- Cálculo: (Pérdida del Segmento / Pérdida Total) * 100
    -- Nota: La conversión a numeric es necesaria para la función ROUND en PostgreSQL
    ROUND(
        ((total_loss / SUM(total_loss) OVER()) * 100)::numeric, 2) AS loss_share_pct

FROM grouped_causes
ORDER BY root_cause;