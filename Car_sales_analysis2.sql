							-- SECTION 1: DATA EXPLORATION & OVERVIEW (Queries 1-5)


-- 1) Dataset Overview: Total records and date range
SELECT 
    COUNT(*) as total_records,
    MIN(saledate_converted) as earliest_sale,
    MAX(saledate_converted) as latest_sale
FROM vehicle_sales;

'Dataset contains 510,518 vehicle sales spanning 18 months (Jan 2014 - Jul 2015),
providing a substantial sample size for analyzing post-recession automotive market trends.'

-- 2) Data Dimensions: Unique values across key attributes
SELECT
    COUNT(DISTINCT make) as unique_makes,
    COUNT(DISTINCT model) as unique_models,
    COUNT(DISTINCT body) as unique_body_types,
    COUNT(DISTINCT seller) as unique_sellers,
    COUNT(DISTINCT state) as unique_states
FROM vehicle_sales;
'
-- Dataset includes 64 unique makes and 835 models across 45 body types, 
sold by 12,672 sellers in 38 states. 
-- The high seller count (12K+) indicates a fragmented distribution network, while limited state coverage suggests regional market focus 
rather than full national representation.'

-- 3) Price Overview: Average selling price across all vehicles
SELECT ROUND(AVG(sellingprice), 2) as avg_sellingprice
FROM vehicle_sales;

'Average selling price of $13,602 positions this dataset in the mid-market segment,
reflecting a mix of economy and mainstream vehicles with some luxury outliers.
This baseline enables comparative analysis across makes, conditions, and mileage ranges.'

-- 4) Vehicle Age Distribution: Sales volume by car make year
SELECT 
    year,
    COUNT(*) as total_units
FROM vehicle_sales
GROUP BY year
ORDER BY total_units DESC;

'2012 models dominate sales at 93,377 units (18.3%), followed by 2013 (90,159) and 
2014 (72,913). This concentration on 2-4 year old vehicles reflects the used car 
sweet spot—past initial depreciation but still reliable, appealing to value-conscious 
buyers seeking newer features without new-car premiums.'

-- 5) Geographic Reach: Sales distribution by state
SELECT 
    state, 
    COUNT(*) as total_sales, 
    ROUND(AVG(sellingprice), 2) as avg_sellingprice
FROM vehicle_sales
GROUP BY state
ORDER BY total_sales DESC;

'Florida leads with 74,767 sales (14.6%), followed by California (67,677, 13.3%) and 
Pennsylvania (50,892, 10.0%). These three states account for 38% of total volume, 
driven by large populations and strong automotive markets. Florida's '
#1 position may reflect favorable climate extending vehicle lifespans and attracting retirees.'

									-- SECTION 2: MARKET ANALYSIS (Queries 6-10)


-- 6) Market Share Analysis: Top 10 makes by volume
SELECT 
    make, 
    COUNT(*) AS units,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM vehicle_sales
GROUP BY make
ORDER BY units DESC
LIMIT 10;

'Ford dominates with 80,937 units (15.85% market share), followed by Chevrolet 
(56,870, 11.14%) and Nissan (49,126, 9.62%). Top 3 brands control 36.6% of the 
market, indicating moderate concentration. Ford's ' leadership reflects strong brand 
loyalty and extensive dealer network, particularly for F-Series trucks.'

-- 7) Top Make Deep Dive: Most popular models within leading brand
WITH top_make AS (
    SELECT make
    FROM vehicle_sales
    GROUP BY make
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
SELECT 
    v.model,
    COUNT(*) AS units
FROM vehicle_sales v
JOIN top_make t ON v.make = t.make
GROUP BY v.model
ORDER BY units DESC
LIMIT 10;

-- Ford's top models are F-150 (truck), Fusion (sedan), and Escape (SUV), demonstrating 
-- a diversified portfolio across all major segments. F-150's dominance reinforces 
-- America's truck preference, while Fusion and Escape's strong performance shows Ford 
-- successfully captures both family and commuter markets beyond its truck reputation.

-- 8) Body Type Preferences: Sales distribution by vehicle body

SELECT 
    body, 
    COUNT(*) as total_units,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM vehicle_sales
GROUP BY body
ORDER BY total_units DESC;

-- Sedans dominate at 220,492 units (43.2%), followed by SUVs at 131,679 (25.8%).
-- This sedan preference reflects the 2014-2015 dataset period—before the SUV boom 
-- that reshaped the market post-2016. CTS-V Wagon's minimal sales highlight niche 
-- performance wagons' limited appeal in the American market despite enthusiast interest.

-- 9) State Market Preferences: Most popular body type per state
WITH state_body_counts AS (
    SELECT 
        state, 
        body, 
        COUNT(*) AS total_units,
        RANK() OVER(PARTITION BY state ORDER BY COUNT(*) DESC) AS rnk
    FROM vehicle_sales
    GROUP BY state, body
)
SELECT 
    state,
    body AS most_popular_body_type,
    total_units
FROM state_body_counts
WHERE rnk = 1
ORDER BY state;

-- Sedans dominate in most states, with Florida leading sedan sales volume. SUV 
-- preference emerges in regions with harsher climates (snow-belt states), reflecting 
-- practical needs for all-wheel drive and ground clearance. Geographic body-type 
-- patterns reveal how climate and terrain directly influence consumer vehicle choices.

-- 10) Seasonal Trends: Monthly sales patterns
SELECT 
    CASE SUBSTRING(saledate, 5, 3)
        WHEN 'Jan' THEN 1 WHEN 'Feb' THEN 2 WHEN 'Mar' THEN 3
        WHEN 'Apr' THEN 4 WHEN 'May' THEN 5 WHEN 'Jun' THEN 6
        WHEN 'Jul' THEN 7 WHEN 'Aug' THEN 8 WHEN 'Sep' THEN 9
        WHEN 'Oct' THEN 10 WHEN 'Nov' THEN 11 WHEN 'Dec' THEN 12
    END AS month_number,
    SUBSTRING(saledate, 5, 3) AS month_name,
    COUNT(*) AS total_units
FROM vehicle_sales
GROUP BY month_number, month_name
ORDER BY total_units DESC;

-- February leads in sales volume, followed by January and June, while July shows 
-- the lowest. The Q1 surge (Jan-Feb peak) aligns with tax refund season when consumers 
-- have increased purchasing power. July's slowest performance likely reflects summer 
-- vacation spending competition and dealership inventory constraints mid-model-year.

										-- SECTION 3: PRICING ANALYSIS (Queries 11-15)


-- 11) Premium Vehicles: Top 10 most expensive sales
SELECT 
    make, 
    model, 
    year, 
    sellingprice
FROM vehicle_sales
ORDER BY sellingprice DESC
LIMIT 10;

-- Top 3 highest-priced sales: Ferrari 458 Italia ($183,000), Mercedes-Benz S-Class 
-- ($173,000), and Rolls-Royce Ghost ($169,500). These exotic and ultra-luxury vehicles 
-- sell at 12-13x the market average ($13,602), indicating the dataset includes specialty 
-- dealers and high-net-worth buyers alongside mainstream retail transactions.

-- 12) Luxury Brand Premiums: Average prices by make
SELECT 
    make, 
    COUNT(*) as units_sold,
    ROUND(AVG(sellingprice), 2) AS avg_selling_price
FROM vehicle_sales
GROUP BY make
HAVING COUNT(*) >= 100
ORDER BY avg_selling_price DESC
LIMIT 15;

-- Bentley commands the highest average selling price at $73,476, followed by Maserati 
-- ($44,524) and Porsche ($40,251). These luxury brands average 3-5x the market baseline, 
-- confirming their premium positioning. The $29K gap between Bentley and Maserati shows 
-- distinct ultra-luxury vs luxury tiers, reflecting brand heritage and exclusivity premiums.

-- 13) Multi-dimensional Pricing: By make, body type, and condition
SELECT 
    make, 
    body, 
    `condition`,
    AVG(sellingprice) AS avg_selling_price,
    COUNT(*) AS total_sales
FROM vehicle_sales
GROUP BY make, body, `condition`
HAVING COUNT(*) > 100
ORDER BY avg_selling_price DESC
LIMIT 20;

-- BMW SUVs lead at $38,947 average price, with BMW sedans close behind at $37,192.
-- BMW's dominance in both segments (nearly 3x market average) demonstrates strong 
-- brand equity across body types. The minimal $1,755 SUV premium suggests BMW buyers 
-- prioritize brand prestige over body style, unlike mainstream segments where SUVs 
-- command steeper premiums.

-- 14) Color Impact on Price: Average selling price by color
SELECT 
    color, 
    COUNT(*) as units_sold,
    ROUND(AVG(sellingprice), 2) as avg_sellingprice
FROM vehicle_sales
GROUP BY color
HAVING COUNT(*) >= 1000
ORDER BY avg_sellingprice DESC;

-- Black vehicles command the highest average price at $15,668, while green ranks 
-- lowest at $8,580—an 82% price gap. This likely reflects brand composition rather 
-- than pure color preference: luxury brands predominantly offer black, while green 
-- appears more in economy segments. Neutral colors (black, white, silver) maintain 
-- stronger resale value due to broader buyer appeal.

-- 15) Mileage Impact: Price variation across odometer ranges
SELECT 
    CASE 
        WHEN odometer <= 25000 THEN '0-25K'
        WHEN odometer <= 50000 THEN '25-50K'
        WHEN odometer <= 75000 THEN '50-75K'
        WHEN odometer <= 100000 THEN '75-100K'
        ELSE '100K+'
    END AS odometer_range,
    COUNT(*) as total_units,
    ROUND(AVG(sellingprice), 2) AS avg_sellingprice
FROM vehicle_sales
GROUP BY odometer_range
ORDER BY avg_sellingprice DESC;

-- Vehicles with 0-50K miles maintain stable pricing around $20,800, but depreciation 
-- accelerates sharply beyond 50K: dropping 36% to $13,370 at 50-75K miles, then 
-- plummeting 75% overall to just $5,148 at 100K+ miles. The 100K threshold represents 
-- a critical value cliff—vehicles lose over half their worth crossing this psychological 
-- and mechanical reliability barrier, creating optimal buy opportunities for budget-conscious 
-- buyers and urgent sell signals for owners approaching this milestone.

									-- SECTION 4: DEPRECIATION & VALUE ANALYSIS (Queries 16-17)


-- 16) Vehicle Age Impact: Odometer readings for older vehicles
SELECT 
    ROUND(AVG(odometer), 2) as avg_odometer_reading
FROM vehicle_sales
WHERE (2025 - year) > 10;

-- Vehicles older than 10 years average 69,065 miles, translating to approximately 
-- 6,900 miles per year—well below the national average of 12-15K miles annually. 
-- This suggests the dataset includes many low-usage vehicles (weekend cars, retirees, 
-- urban drivers) or well-maintained fleet vehicles, which could explain relatively 
-- strong pricing retention in older model years.

-- 17) Depreciation Trends: Year-over-year price changes for top makes
WITH top_makes AS (
    SELECT make, COUNT(*) AS total_sales
    FROM vehicle_sales
    GROUP BY make
    ORDER BY total_sales DESC
    LIMIT 5
),
yearly_prices AS (
    SELECT 
        vs.make,
        vs.year,
        AVG(vs.sellingprice) AS avg_price,
        COUNT(*) AS units_sold
    FROM vehicle_sales vs
    INNER JOIN top_makes tm ON vs.make = tm.make
    GROUP BY vs.make, vs.year
)
SELECT 
    make,
    year,
    ROUND(avg_price, 2) as avg_price,
    units_sold,
    ROUND(LAG(avg_price) OVER(PARTITION BY make ORDER BY year), 2) AS prev_year_price,
    ROUND(avg_price - LAG(avg_price) OVER(PARTITION BY make ORDER BY year), 2) AS price_change,
    ROUND(((avg_price - LAG(avg_price) OVER(PARTITION BY make ORDER BY year)) / 
           LAG(avg_price) OVER(PARTITION BY make ORDER BY year)) * 100, 2) AS change_percent
FROM yearly_prices
ORDER BY make, year;

-- Year-over-year analysis reveals Toyota maintains superior value retention with 
-- consistently positive appreciation in recent model years (10-33% annual gains for 
-- 2006-2015 models), while Chevrolet experiences volatile depreciation ranging from 
-- -61% to +129% depending on model year. Toyota's stable resale performance reflects 
-- its reliability reputation, making it the preferred choice in used markets. Domestic 
-- brands show erratic patterns, with sharp drops after initial years, creating both 
-- risk for sellers and value opportunities for strategic buyers.

								-- SECTION 5: SELLER & MARKET PERFORMANCE (Queries 18-20)


-- 18) Top Sellers by Revenue: Total sales and volume
SELECT 
    seller, 
    SUM(sellingprice) as total_revenue,
    COUNT(*) as total_volume,
    ROUND(AVG(sellingprice), 2) as avg_sale_price
FROM vehicle_sales
GROUP BY seller
ORDER BY total_revenue DESC, total_volume DESC
LIMIT 10;

-- Top revenue generators are Ford Motor Company, Nissan-Infiniti, and Hertz Corporation, 
-- representing two distinct business models: OEM captive finance operations (Ford, Nissan) 
-- moving off-lease vehicles, and fleet rental liquidation (Hertz). OEM sellers leverage 
-- manufacturer brand equity and CPO programs to maximize prices, while Hertz benefits 
-- from high-volume fleet turnover. This concentration among manufacturer-affiliated 
-- sellers indicates the used car market is largely controlled by OEM distribution 
-- networks rather than independent dealers.

-- 19) Seller Performance vs Market Value: Above/below MMR analysis
SELECT 
    seller, 
    COUNT(*) as total_units,
    ROUND(AVG((sellingprice - mmr)/mmr * 100), 2) as avg_premium_vs_mmr_pct,
    ROUND(AVG(sellingprice - mmr), 2) as avg_premium_dollars
FROM vehicle_sales
WHERE sellingprice IS NOT NULL 
    AND mmr IS NOT NULL
    AND sellingprice > mmr
GROUP BY seller
HAVING COUNT(*) >= 100
ORDER BY total_units DESC
LIMIT 10;

-- Nissan-Infiniti achieves the highest performance vs. MMR at +$1,110 per vehicle, 
-- followed by Ford (+$1,020) and Hertz (+$501). OEM-affiliated sellers (Nissan-Infiniti, 
-- Ford) command 2x the premium of rental fleet operators (Hertz), reflecting stronger 
-- brand control, certified pre-owned programs, and warranty offerings. Consistently 
-- selling above market value indicates pricing power through brand reputation and 
-- structured reconditioning processes rather than volume discounting strategies.

-- 20) Market Value Analysis: Average delta between selling price and MMR by make
SELECT 
    make,
    COUNT(*) AS units,
    ROUND(AVG(sellingprice - mmr), 2) AS avg_delta_vs_mmr,
    ROUND(AVG((sellingprice - mmr)/mmr * 100), 2) as avg_pct_vs_mmr
FROM vehicle_sales
WHERE sellingprice IS NOT NULL AND mmr IS NOT NULL
GROUP BY make
HAVING COUNT(*) >= 100
ORDER BY avg_delta_vs_mmr DESC
LIMIT 15;

-- Hummer commands the strongest brand premium at +$2,252 above MMR (+1.56%), despite 
-- limited volume (756 units). This specialty brand's ability to exceed market value 
-- reflects strong enthusiast demand and scarcity appeal, particularly post-discontinuation 
-- (GM ended production in 2010). Niche vehicles with cult followings maintain pricing 
-- power independent of volume, demonstrating that brand desirability trumps market 
-- efficiency in collectible segments.