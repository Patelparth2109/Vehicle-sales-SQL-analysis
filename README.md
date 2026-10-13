# Vehicle Sales SQL Analysis

SQL analysis of 510,518 U.S. used-vehicle auction sales (January 2014 to July 2015) covering market composition, pricing, mileage and age effects, depreciation, and seller performance against the Manheim Market Report (MMR) benchmark. The 20 queries use aggregations, CTEs, and window functions (`RANK`, `LAG`, windowed `SUM`).

## Key Findings

**Market composition**
- 64 makes and 835 models sold by 12,672 sellers across 38 states.
- Ford leads with 15.9% of units, followed by Chevrolet (11.1%) and Nissan (9.6%). Ford's top models are the F-150, Fusion, and Escape.
- Sedans account for 43.2% of sales and SUVs for 25.8%.
- 2012 to 2014 model years make up nearly half of all sales, concentrated in two-to-four-year-old vehicles.

**Geography and seasonality**
- Florida (14.6%), California (13.3%), and Pennsylvania (10.0%) together account for 38% of volume.
- February and January are the strongest months; July is the weakest.

**Pricing**
- Average selling price is $13,602.
- Among makes with at least 100 sales, Bentley has the highest average price ($73,476), followed by Maserati and Porsche.
- Price falls sharply with mileage: vehicles under 50K miles average about $20,800, the 50K to 75K band averages $13,370, and vehicles over 100K average $5,148.
- Black vehicles have the highest average price by color ($15,668) and green the lowest ($8,580), a gap that likely reflects brand mix rather than color preference alone.

**Sellers and market value**
- The highest-revenue sellers are OEM finance arms (Ford, Nissan-Infiniti) and rental fleets (Hertz).
- Among makes with at least 100 sales, Hummer sells furthest above MMR (+$2,252 on average).

## Query Index

| # | Section | Technique |
|---|---|---|
| 1 to 5 | Data overview: volume, dimensions, price baseline, model year, state | Aggregation |
| 6 to 10 | Market share, top models, body types, state preferences, seasonality | Windowed `SUM`, CTE, `RANK() OVER (PARTITION BY)` |
| 11 to 15 | Premium sales, brand pricing, make/body/condition, color, mileage bands | `HAVING`, `CASE` bucketing |
| 16 to 17 | Mileage of older vehicles, year-over-year price change by make | Multi-CTE, `LAG` |
| 18 to 20 | Seller revenue, seller and make performance vs. MMR | Aggregation, ratio metrics |

## Data

**Source:** [Vehicle Sales Data](https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data) (Kaggle)

Load the CSV into a MySQL table named `vehicle_sales`. The queries expect one derived column, `saledate_converted` (a `DATETIME` parsed from the raw `saledate` text), and rows with missing key fields removed, which yields the 510,518 rows analyzed.

Columns used: `year`, `make`, `model`, `body`, `state`, `condition`, `odometer`, `color`, `seller`, `mmr`, `sellingprice`, `saledate`, `saledate_converted`.

## Usage

```bash
mysql -u <user> -p <database> < sql/vehicle_sales_analysis.sql
```

Or open the file in MySQL Workbench or DBeaver and run queries individually. Each query is followed by a comment summarizing its result.

## Tech Stack

MySQL 8.0, MySQL Workbench / DBeaver

## Author

Parth Patel · [LinkedIn](https://www.linkedin.com/in/parth-patel-03800917a/)
