-- 5. FACT TABLE fact_order_lines : SALES & PROFITABILITY
-- Goal: Central table with metrics and foreign keys.
-- Objetivo: Tabla central con métricas y claves foráneas.
-- ===============================================================
DROP TABLE IF EXISTS fact_order_lines;

CREATE TABLE fact_order_lines AS
SELECT 
    -- IDs Clave
    s.order_id, 
    s.order_item_id,
	--foreign keys/claves foráneas
    s.customer_id,
    s.product_card_id,
    g.geo_id, 
    d.shipping_id,

    --Dates/ Fechas
    s.order_date,
    s.shipping_date,

    -- Financial metrics/ Métricas Financieras (LÓGICA DE NEGOCIO APLICADA)
    s.sales,
    s.order_item_quantity AS quantity,
    s.order_item_discount AS discount,
    
    -- Profit Limpio (Sin falsos positivos en cancelados)
    CASE 
        WHEN s.order_status IN ('CANCELED', 'SUSPECTED_FRAUD') AND s.order_profit_per_order > 0 
        THEN 0 
        ELSE s.order_profit_per_order 
    END AS real_profit,
    
    -- Métricas Operativas
    s.days_for_shipping_real AS days_shipping_real,
    s.days_for_shipping_scheduled AS days_shipping_scheduled,
    (s.days_for_shipping_real - s.days_for_shipping_scheduled) AS days_delay,

    -- Estados
    s.order_status,
    s.delivery_status
FROM staging_supply_chain s
-- Joins para obtener los IDs de las dimensiones nuevas
LEFT JOIN dim_geography g ON s.order_city = g.city AND s.order_state = g.state AND s.order_country = g.country
LEFT JOIN dim_shipping d ON s.shipping_mode = d.shipping_mode;

-- Primary Key 
ALTER TABLE fact_order_lines ADD PRIMARY KEY (order_item_id);