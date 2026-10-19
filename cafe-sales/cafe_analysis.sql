-- CAFE SALES ANALYSIS
-- Data: Simulated cafe sales dataset for portfolio purposes
-- Tool: SQL

-- Q1: รายได้รวมทั้งหมด
-- ผล: Total revenue across all transactions
SELECT 
  SUM(total_sales) AS total_revenue
FROM cafe_transactions;

-- Q2: จำนวนธุรกรรมทั้งหมด
-- ผล: Total number of transactions
SELECT 
  COUNT(*) AS total_transactions
FROM cafe_transactions;

-- Q3: จำนวนสินค้าที่ขายทั้งหมด
-- ผล: Total items sold
SELECT 
  SUM(quantity_sold) AS total_items_sold
FROM cafe_transactions;

-- Q4: ยอดขายแยกตามหมวดสินค้า
-- ผล: Revenue breakdown by product category
SELECT 
  product_category,
  SUM(total_sales) AS revenue,
  ROUND(SUM(total_sales) * 100.0 / (SELECT SUM(total_sales) FROM cafe_transactions), 2) AS pct
FROM cafe_transactions
GROUP BY product_category
ORDER BY revenue DESC;

-- Q5: สินค้าที่ขายดีที่สุด 5 อันดับ (เรียงตามจำนวนที่ขาย)
-- ผล: Top 5 best-selling items by quantity
SELECT 
  item_name,
  SUM(quantity_sold) AS total_qty,
  SUM(total_sales) AS revenue
FROM cafe_transactions
GROUP BY item_name
ORDER BY total_qty DESC
LIMIT 5;

-- Q6: ยอดขายตามชั่วโมง (Peak hours 12:00-14:00)
-- ผล: Sales distribution by hour to identify peak periods
SELECT 
  strftime('%H', datetime) AS hour,
  COUNT(*) AS transactions,
  SUM(total_sales) AS revenue
FROM cafe_transactions
GROUP BY hour
ORDER BY hour;

-- Q7: เปรียบเทียบยอดขายวันจันทร์-อาทิตย์
-- ผล: Sales by day of week
SELECT 
  CASE strftime('%w', datetime)
    WHEN '0' THEN 'Sunday'
    WHEN '1' THEN 'Monday'
    WHEN '2' THEN 'Tuesday'
    WHEN '3' THEN 'Wednesday'
    WHEN '4' THEN 'Thursday'
    WHEN '5' THEN 'Friday'
    WHEN '6' THEN 'Saturday'
  END AS day_of_week,
  COUNT(*) AS transactions,
  SUM(total_sales) AS revenue,
  ROUND(AVG(total_sales), 2) AS avg_order_value
FROM cafe_transactions
GROUP BY day_of_week
ORDER BY revenue DESC;

-- Q8: ช่องทางการชำระเงิน
-- ผล: Payment method breakdown
SELECT 
  payment_method,
  COUNT(*) AS transactions,
  SUM(total_sales) AS revenue,
  ROUND(SUM(total_sales) * 100.0 / (SELECT SUM(total_sales) FROM cafe_transactions), 2) AS pct
FROM cafe_transactions
GROUP BY payment_method
ORDER BY revenue DESC;

-- Q9: ค่าเฉลี่ยต่อใบเสร็จ (AOV)
-- ผล: Average order value - Weekend vs Weekday
SELECT 
  CASE 
    WHEN strftime('%w', datetime) IN ('0','6') THEN 'Weekend'
    ELSE 'Weekday'
  END AS period,
  ROUND(AVG(total_sales), 2) AS avg_order_value,
  COUNT(*) AS transactions
FROM cafe_transactions
GROUP BY period;

-- Q10: สัดส่วนธุรกรรมช่วงเที่ยง-บ่าย (12:00-14:00)
-- ผล: Lunch peak period analysis (~40% of daily transactions)
SELECT 
  ROUND(COUNT(CASE WHEN CAST(strftime('%H', datetime) AS INT) BETWEEN 12 AND 14 THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_lunch_peak
FROM cafe_transactions;
