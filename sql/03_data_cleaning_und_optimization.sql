/* * -----------------------------------------------------------
 * STEP 3: Data Type Conversion / Conversión de Tipos de Datos
 * -----------------------------------------------------------
 * Goal: Convert text dates (US Format) to Timestamp for time calculations.
 * Objetivo: Convertir fechas en texto (Formato EEUU) a Timestamp para cálculos de tiempo.
 */

-- 1. Convert order_date
-- Using to_timestamp to handle 'MM/DD/YYYY HH:MI' format explicitly.
-- Usamos to_timestamp para manejar explícitamente el formato 'MM/DD/YYYY HH:MI'.
ALTER TABLE staging_supply_chain
ALTER COLUMN order_date TYPE TIMESTAMP
USING to_timestamp(order_date, 'MM/DD/YYYY HH24:MI');

-- 2. Convert shipping_date
ALTER TABLE staging_supply_chain
ALTER COLUMN shipping_date TYPE TIMESTAMP
USING to_timestamp(shipping_date, 'MM/DD/YYYY HH24:MI');

--3. Data Cleaning / Limpieza de Datos
-- GOAL: Drop constant columns (cardinality=1) and sensitive PII.
-- OBJETIVO: Eliminar columnas constantes (cardinalidad=1) y datos sensibles (PII).
ALTER TABLE staging_supply_chain
DROP COLUMN IF EXISTS product_status,      
DROP COLUMN IF EXISTS product_description, 
DROP COLUMN IF EXISTS customer_password,   
DROP COLUMN IF EXISTS customer_email;      