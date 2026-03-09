# Notebooks overview

These two notebooks are used together to forecast **hourly delivery demand** per zone (**AOI**) from the LaDe (Cainiao) last-mile dataset.

## `LaDe.ipynb` (preprocessing + feature engineering)

Purpose: turn raw order-level LaDe data into an **hourly AOI-level time series dataset** ready for modeling.

What it does:
- Loads raw pickup/order data (e.g., `pickup_cq.csv` from Google Drive in Colab).
- Parses timestamps (dataset spans **2022-05 to 2022-10**) and buckets them into **hourly** time windows (`bucket_hour`).
- Aggregates to the forecasting unit `(city, region_id, aoi_id, bucket_hour)` and creates the target:
  - `demand_count` = number of orders in that AOI during that hour.
- Fills missing hours per AOI with `demand_count = 0` to make a continuous hourly series.
- Builds basic time features (`hour`, `dow`, `month`, weekend flags).
- Builds lag + rolling features (e.g., `lag_1`, `lag_24`, `lag_168`, `roll_24_mean`, `roll_168_mean`).
- Exports the final feature table to **`lade_hourly_features.csv`**.

## `LaDe_XGBoost_Forecast.ipynb` (model training + evaluation)

Purpose: train and evaluate an **XGBoost regression** model to predict `demand_count` using the engineered features.

What it does:
- Loads the preprocessed dataset from **`lade_hourly_features.csv`** (or reuses `model_df` if already in memory).
- Optionally adds extra time/spatial features (e.g., `hour_sin/cos`, holiday/Ramadan flags, `neighbor_lag_24_mean`, `aoi_area`).
- Splits data **chronologically** into train/val/test to avoid leakage.
- Compares against simple baselines (`lag_24`, `roll_24_mean`).
- Trains XGBoost (plus optional variants like **zero-inflated** and `reg:squaredlogerror`).
- Evaluates with **MAE / RMSE / sMAPE** and produces plots (learning curves, feature importance, example AOI predictions).

## Typical workflow

1. Run `LaDe.ipynb` to generate `lade_hourly_features.csv`.
2. Run `LaDe_XGBoost_Forecast.ipynb` to train and evaluate the forecasting model.

