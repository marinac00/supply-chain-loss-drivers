/* ==============================================================================
 SCRIPT: 06_create_dm_customer_rfm.sql
 OBJECTIVE: Create a Customer Data Mart for RFM and Profitability Analysis.
 OBJETIVO: Crear un Data Mart de Clientes para análisis RFM y Rentabilidad.
 
 GRANULARITY: 1 Row per Customer.
 GRANULARIDAD: 1 Fila por Cliente.
 
 SNAPSHOT DATE: 2018-02-01 (Day after the dataset ends / Día post-datos).
 ==============================================================================
*/

DROP TABLE IF EXISTS dm_customer_rfm;

CREATE TABLE dm_customer_rfm AS --CTE 
WITH customer_summary AS (
    SELECT 
        customer_id,
        -- Aggregated Metrics / Métricas Agregadas
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS frequency_orders, -- Total unique orders / Total pedidos únicos
        SUM(sales) AS total_sales,
        SUM(real_profit) AS total_profit, -- Using the CLEAN profit / Usando el profit LIMPIO
        
        -- Risk Metric: Count cancellations to detect problematic behavior
        -- Métrica de Riesgo: Contamos cancelaciones para detectar comportamiento problemático
        COUNT(DISTINCT CASE WHEN order_status = 'CANCELED' THEN order_id END) AS canceled_orders
    FROM 
        fact_order_lines
    GROUP BY 
        customer_id
)
SELECT --tabla final usando CTE
    customer_id,
    last_order_date,
    
    -- RECENCY (R): Days since last purchase until "simulated present"
    -- RECENCIA (R): Días desde la última compra hasta el "presente simulado"
    DATE_PART('day', '2018-02-01'::timestamp - last_order_date::timestamp) AS recency_days,
    
    frequency_orders,
    canceled_orders,
    
    -- Cancellation Rate / Tasa de Cancelación
    CASE 
        WHEN frequency_orders = 0 THEN 0 
        ELSE ROUND((canceled_orders::numeric / frequency_orders::numeric), 2) 
    END AS cancellation_rate,
    
    total_sales,
    total_profit,
    
    -- MONETARY (M) / PROFITABILITY: Profit Margin %
    -- MONETARIO (M) / RENTABILIDAD: Margen de Beneficio %
    ROUND((total_profit::numeric / NULLIF(total_sales, 0)::numeric) * 100, 2) AS profit_margin_pct

FROM 
    customer_summary;

-- Add Primary Key for performance / Añadimos Primary Key para rendimiento
ALTER TABLE dm_customer_rfm ADD PRIMARY KEY (customer_id);