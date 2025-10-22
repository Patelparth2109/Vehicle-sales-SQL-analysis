🚗 Vehicle Sales SQL Analysis

Analyzed 510K+ used vehicle transactions using SQL to uncover pricing, depreciation, and seller profitability trends.

 🧠 Objectives
- Identify top-selling makes and models
- Measure average selling price, margin vs MMR benchmark
- Evaluate state-level sales performance
- Analyze depreciation by make and model year
- Detect outliers and best-value vehicles

🧰 Tech Stack
Language: SQL (PostgreSQL/MySQL)  
Tools: DBeaver / pgAdmin / MySQL Workbench  
Data: 510,518 vehicle sales records (`vehicle_sales` table)

 📊 Key Queries (20 total)
| Category | Example |
|-----------|----------|
| Volume & Coverage | Total sales, unique makes, models, states |
| Pricing | Avg/median price, margin vs MMR |
| Time Trends | Monthly & yearly sales, depreciation |
| Geography | Top states & sellers |
| Advanced | Window functions for ranking, LAG for year-over-year price |

 📈 Highlights
- Ford is the top-selling make; F-150 is the best-selling model.  
- BMW SUVs lead in average selling price ($38K+).  
- Florida records the most sales volume; Alaska the least.  
- Price drops ~40% after 100K odometer readings.  
- Nissan-Infiniti dealers achieved the highest margin above MMR (+8.3%).

 📚 Next Steps
- Build Tableau dashboard with KPIs (Volume, Margin, Depreciation, Seller Ranking)
- Add performance optimization & indexing benchmarks
- Publish visual insights and conclusions

---

👤 Author: Parth Patel  
🎓 MSDAIS – Texas State University  
📅 October 2025  
