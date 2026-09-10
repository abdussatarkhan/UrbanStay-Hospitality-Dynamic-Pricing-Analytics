-- ============================================================================
-- UrbanStay: Global Hospitality & Short-Term Rental Dynamic Pricing Analytics - Advanced Analytical SQL Suite
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

-- Query 3: Statistical Z-Score Outlier & Anomaly Detection CTE
WITH metric_stats AS (
    SELECT 
        f.event_id,
        f.date_key,
        f.metric_value_usd,
        f.latency_duration_mins,
        AVG(f.latency_duration_mins) OVER () AS mean_latency,
        STDDEV(f.latency_duration_mins) OVER () AS std_latency
    FROM urbanstay_dw.fact_room_nights f
)
SELECT 
    event_id,
    date_key,
    latency_duration_mins,
    ROUND((latency_duration_mins - mean_latency) / NULLIF(std_latency, 0), 2) AS latency_z_score,
    CASE 
        WHEN ABS((latency_duration_mins - mean_latency) / NULLIF(std_latency, 0)) >= 3.0 THEN 'CRITICAL_OUTLIER'
        WHEN ABS((latency_duration_mins - mean_latency) / NULLIF(std_latency, 0)) >= 2.0 THEN 'WARNING_ELEVATED'
        ELSE 'NORMAL_BOUNDS'
    END AS anomaly_classification
FROM metric_stats
WHERE ABS((latency_duration_mins - mean_latency) / NULLIF(std_latency, 0)) >= 2.0
ORDER BY latency_z_score DESC;

-- Query 4: Month-over-Month Revenue Growth with LAG() Window Function
WITH monthly_revenue AS (
    SELECT 
        dt.year,
        dt.month,
        SUM(f.metric_value_usd) AS monthly_revenue_usd
    FROM urbanstay_dw.fact_room_nights f
    JOIN urbanstay_dw.dim_date dt ON f.date_key = dt.date_key
    GROUP BY dt.year, dt.month
)
SELECT 
    year,
    month,
    monthly_revenue_usd,
    LAG(monthly_revenue_usd, 1) OVER (ORDER BY year, month) AS prior_month_revenue,
    ROUND(
        (monthly_revenue_usd - LAG(monthly_revenue_usd, 1) OVER (ORDER BY year, month)) 
        / NULLIF(LAG(monthly_revenue_usd, 1) OVER (ORDER BY year, month), 0) * 100.0, 
        2
    ) AS mom_growth_rate_pct
FROM monthly_revenue
ORDER BY year DESC, month DESC;

-- Query 5: P50, P90, and P99 Latency SLA Percentiles
SELECT 
    COUNT(event_id) AS sample_size,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY latency_duration_mins)::NUMERIC, 2) AS p50_median_latency_mins,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY latency_duration_mins)::NUMERIC, 2) AS p90_latency_mins,
    ROUND(PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY latency_duration_mins)::NUMERIC, 2) AS p99_latency_mins,
    ROUND(AVG(latency_duration_mins), 2) AS mean_latency_mins
FROM urbanstay_dw.fact_room_nights;
