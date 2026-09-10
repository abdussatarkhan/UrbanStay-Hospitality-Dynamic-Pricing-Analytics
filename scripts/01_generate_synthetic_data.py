"""
UrbanStay: Global Hospitality & Short-Term Rental Dynamic Pricing Analytics - Synthetic Telemetry Data Generator
"""
import argparse
import datetime
import os
import random
import pandas as pd
import numpy as np

def generate_dataset(n_records=10000, output_dir="data"):
    os.makedirs(output_dir, exist_ok=True)
    random.seed(42)
    np.random.seed(42)
    
    print(f"Generating {n_records} records for UrbanStay-Hospitality-Dynamic-Pricing-Analytics...")
    records = []
    base_date = datetime.date(2024, 1, 1)
    
    for i in range(1, n_records + 1):
        dt = base_date + datetime.timedelta(days=random.randint(0, 364))
        records.append({
            "event_id": i,
            "date": dt.strftime("%Y-%m-%d"),
            "metric_value_usd": round(float(np.random.lognormal(5.0, 0.6)), 2),
            "latency_duration_mins": round(float(np.random.exponential(24.0)), 1),
            "is_sla_compliant": bool(random.random() < 0.94)
        })
        
    df = pd.DataFrame(records)
    df.to_csv(os.path.join(output_dir, "fact_events.csv"), index=False)
    print(f"Saved dataset to {output_dir}/fact_events.csv ({len(df)} rows)")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--records", type=int, default=10000)
    parser.add_argument("--out", type=str, default="data")
    args = parser.parse_args()
    generate_dataset(args.records, args.out)
