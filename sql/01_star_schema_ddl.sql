-- ============================================================================
-- UrbanStay: Global Hospitality & Short-Term Rental Dynamic Pricing Analytics
-- Star Schema DDL (PostgreSQL 16 Enterprise Spec)
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS urbanstay_dw;
SET search_path TO urbanstay_dw, public;

-- Date Dimension
CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day_name VARCHAR(12) NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    month INT NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_properties (
    properties_key SERIAL PRIMARY KEY,
    properties_code VARCHAR(32) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status_tier VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_room_types (
    room_types_key SERIAL PRIMARY KEY,
    room_types_code VARCHAR(32) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status_tier VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_booking_channels (
    booking_channels_key SERIAL PRIMARY KEY,
    booking_channels_code VARCHAR(32) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status_tier VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_guest_segments (
    guest_segments_key SERIAL PRIMARY KEY,
    guest_segments_code VARCHAR(32) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status_tier VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fact_room_nights (
    event_id BIGSERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES dim_date(date_key),
    metric_value_usd NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    operational_count INT NOT NULL DEFAULT 1,
    latency_duration_mins NUMERIC(8, 2) NOT NULL DEFAULT 0.0,
    is_sla_compliant BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fact_revenue_movements (
    event_id BIGSERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES dim_date(date_key),
    metric_value_usd NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    operational_count INT NOT NULL DEFAULT 1,
    latency_duration_mins NUMERIC(8, 2) NOT NULL DEFAULT 0.0,
    is_sla_compliant BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fact_cancellations (
    event_id BIGSERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES dim_date(date_key),
    metric_value_usd NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    operational_count INT NOT NULL DEFAULT 1,
    latency_duration_mins NUMERIC(8, 2) NOT NULL DEFAULT 0.0,
    is_sla_compliant BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fact_guest_reviews (
    event_id BIGSERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES dim_date(date_key),
    metric_value_usd NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    operational_count INT NOT NULL DEFAULT 1,
    latency_duration_mins NUMERIC(8, 2) NOT NULL DEFAULT 0.0,
    is_sla_compliant BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

