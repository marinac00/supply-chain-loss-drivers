-- ARCHIVO: 04_create_dimensions.sql

-- ===============================================================
-- 1. DIMENSION: PRODUCTS / PRODUCTOS
-- Goal: Unique catalog of products including category info (Denormalized/Star Schema).
-- Objetivo: Catálogo único de productos incluyendo info de categoría (Desnormalizado/Esquema Estrella).
-- ===============================================================

DROP TABLE IF EXISTS dim_products CASCADE;

CREATE TABLE dim_products (
    product_card_id    INTEGER PRIMARY KEY, -- Primary Key / Clave Primaria
    product_name       VARCHAR(255),
    product_price      FLOAT,               -- Base Price / Precio Base
    product_image      VARCHAR(500),        -- Image URL / URL Imagen
    category_id        INTEGER,             -- Kept for reference / Mantenido por referencia
    category_name      VARCHAR(255)         -- Category included here to avoid extra Joins / Categoría incluida para evitar Joins extra
);

-- Insert unique data / Insertar datos únicos
INSERT INTO dim_products (
    product_card_id,
    product_name,
    product_price,
    product_image,
    category_id,
    category_name
)
SELECT DISTINCT 
    product_card_id,
    product_name,
    product_price,
    product_image,
    category_id,
    category_name
FROM staging_supply_chain
WHERE product_card_id IS NOT NULL;

-- ===============================================================
-- 2. DIMENSION: CUSTOMERS / CLIENTES
-- Goal: Unique list of customers with their location and segment.
-- Objetivo: Lista única de clientes con su ubicación y segmento.
-- ===============================================================

DROP TABLE IF EXISTS dim_customers CASCADE;

CREATE TABLE dim_customers (
    customer_id       INTEGER PRIMARY KEY,
    customer_fname    VARCHAR(100),
    customer_lname    VARCHAR(100),
    customer_segment  VARCHAR(100),
    customer_street   VARCHAR(255), 
    customer_city     VARCHAR(100),
    customer_state    VARCHAR(100),
    customer_country  VARCHAR(100),
    customer_zipcode  VARCHAR(50)   -- Text to keep leading zeros / Texto para mantener ceros
);

-- Insert unique customers / Insertar clientes únicos
INSERT INTO dim_customers (
    customer_id,
    customer_fname,
    customer_lname,
    customer_segment,
    customer_street,
    customer_city,
    customer_state,
    customer_country,
    customer_zipcode
)
SELECT DISTINCT 
    customer_id,cas
    customer_fname,
    customer_lname,
    customer_segment,
    customer_street, 
    customer_city,
    customer_state,
    customer_country,
    customer_zipcode
FROM staging_supply_chain
WHERE customer_id IS NOT NULL;

-- ===============================================================
-- 3. DIMENSION: SHIPPING / ENVÍO
-- Goal: Unique shipping modes.
-- Objetivo: Modos de envío únicos.
-- Challenge: Source has no ID, so we create a surrogate key (SERIAL).
-- Reto: El origen no tiene ID, creamos una clave sustituta (SERIAL).
-- ===============================================================

DROP TABLE IF EXISTS dim_shipping CASCADE;

CREATE TABLE dim_shipping (
    shipping_id     SERIAL PRIMARY KEY,  -- Auto-increment (1, 2, 3...)
    shipping_mode   VARCHAR(50)
);

-- Insert unique modes
INSERT INTO dim_shipping (shipping_mode)
SELECT DISTINCT shipping_mode
FROM staging_supply_chain
WHERE shipping_mode IS NOT NULL;

-- ===============================================================
-- 4. DIMENSION: GEOGRAPHY / GEOGRAFÍA
-- Goal: Denormalize location data to clean up the Fact Table.
-- Objetivo: Desnormalizar datos de ubicación para limpiar la Fact Table.
-- Strategy: Star Schema (City, State, Country in one table).
-- ===============================================================

DROP TABLE IF EXISTS dim_geography CASCADE;

CREATE TABLE dim_geography (
    geo_id          SERIAL PRIMARY KEY, -- ID Autoincremental (1, 2, 3...)
    city            VARCHAR(100),
    state           VARCHAR(100),
    country         VARCHAR(100),
    region          VARCHAR(100),
    market          VARCHAR(50)
);

-- Insert unique locations (Order Destination)
-- Insertamos combinaciones únicas de destino de pedido
INSERT INTO dim_geography (city, state, country, region, market)
SELECT DISTINCT 
    order_city, 
    order_state, 
    order_country, 
    order_region, 
    market
FROM staging_supply_chain
WHERE order_city IS NOT NULL;


