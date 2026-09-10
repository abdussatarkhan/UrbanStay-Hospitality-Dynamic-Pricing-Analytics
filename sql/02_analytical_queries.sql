-- ============================================================================
-- UrbanStay: Global Hospitality & Short-Term Rental Dynamic Pricing Analytics - Analytical SQL Suite
-- ============================================================================

-- Query 1: Rolling 30-Day Executive Performance Window
SELECT 
    dt.full_date,
    SUM(f.metric_value_usd) AS daily_metric_usd,
    ROUND(AVG(SUM(f.metric_value_usd)) OVER (ORDER BY dt.full_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS rolling_7d_avg,
    ROUND(SUM(CASE WHEN f.is_sla_compliant THEN 1 ELSE 0 END)::NUMERIC / COUNT(f.event_id) * 100.0, 2) AS sla_compliance_rate_pct
FROM urbanstay_dw.fact_room_nights f
JOIN urbanstay_dw.dim_date dt ON f.date_key = dt.date_key
GROUP BY dt.full_date
ORDER BY dt.full_date DESC;

-- Query 2: Segment Pareto Contribution Ranking
SELECT 
    COUNT(f.event_id) AS total_events,
    SUM(f.metric_value_usd) AS total_revenue_usd,
    ROUND(AVG(f.latency_duration_mins), 2) AS mean_latency_mins,
    DENSE_RANK() OVER (ORDER BY SUM(f.metric_value_usd) DESC) AS revenue_rank
FROM urbanstay_dw.fact_room_nights f;
