/* ==============================================================================
 SCRIPT: 08_global_impact_kpis.sql
 AUTHOR: [Tu Nombre]
 OBJECTIVE: Global Impact Assessment.
 OBJETIVO: Evaluación del Impacto Global.
 
 PURPOSE:
 Calculate the magnitude of the problem relative to the company's total profit.
 Calcular la magnitud del problema en relación con el beneficio total de la empresa.
 ==============================================================================
*/

SELECT 
    -- 1. Total Net Profit (Real) / Beneficio Neto Total (Real)
    SUM(real_profit) AS current_net_profit,
    
    -- 2. Total Loss Detected in Audit / Pérdida Total Detectada en Auditoría
    -- We select the sum from our previous View / Seleccionamos la suma de nuestra Vista anterior
    (SELECT SUM(total_loss) FROM vw_loss_drivers) AS identified_losses,
    
    -- 3. Potential Profit (If fixed) / Beneficio Potencial (Si se arregla)
    -- Current Profit - Losses (since losses are negative, we subtract them to add value back)
    -- Beneficio Actual - Pérdidas (como son negativas, restamos para sumar valor)
    SUM(real_profit) - (SELECT SUM(total_loss) FROM vw_loss_drivers) AS potential_profit,
    
    -- 4. % Improvement Opportunity / Oportunidad de Mejora %
    -- Fix: Cast to numeric for rounding
    ROUND(
        (ABS((SELECT SUM(total_loss) FROM vw_loss_drivers) / SUM(real_profit)) * 100)::numeric, 
    2) AS impact_share_pct

FROM fact_order_lines;