-- CAFE SALES ANALYSIS (ข้อมูลสมมติ 1-16 ต.ค. 2026, 343 บิล, 504 รายการ)
-- รันหลัง cafe_data_setup.sql | ตาราง: menu, orders, order_items | เครื่องมือ: SQLite

-- Q1a: จำนวนบิลทั้งหมด
SELECT COUNT(*) AS total_bills
FROM orders;
-- ผลลัพธ์ (total_bills):
--   343

-- Q1b: จำนวนบิลแยกตามช่องทาง
SELECT channel, COUNT(*) AS bill_count
FROM orders
GROUP BY channel;
-- ผลลัพธ์ (channel, bill_count):
--   หน้าร้าน | 254
--   เดลิเวอรี่ | 89

-- Q2: สัดส่วนบิลแยกตามวิธีชำระเงิน (%)
SELECT payment,
       COUNT(*) AS bill_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
GROUP BY payment;
-- ผลลัพธ์ (payment, bill_count, percentage):
--   บัตร | 37 | 10.79
--   เงินสด | 143 | 41.69
--   โอน QR | 163 | 47.52

-- Q3: ยอดขายรวมและกำไรรวม
SELECT SUM(m.price * oi.quantity) AS total_sales,
       SUM((m.price - m.cost) * oi.quantity) AS total_profit
FROM order_items oi
JOIN menu m ON oi.item_id = m.item_id;
-- ผลลัพธ์ (total_sales, total_profit):
--   16625000 | 10587000

-- Q4: เมนูที่กำไรรวมสูงสุด 3 อันดับ
SELECT m.item_name, m.category,
       SUM((m.price - m.cost) * oi.quantity) AS total_profit
FROM order_items oi
JOIN menu m ON oi.item_id = m.item_id
GROUP BY m.item_id, m.item_name, m.category
ORDER BY total_profit DESC
LIMIT 3;
-- ผลลัพธ์ (item_name, category, total_profit):
--   แซนด์วิช | อาหาร | 1672000
--   ลาเต้ | กาแฟ | 1216000
--   คาปูชิโน่ | กาแฟ | 1178000

-- Q5: ยอดขายแยกตามหมวดเมนู
SELECT m.category, SUM(m.price * oi.quantity) AS total_sales
FROM order_items oi
JOIN menu m ON oi.item_id = m.item_id
GROUP BY m.category
ORDER BY total_sales DESC;
-- ผลลัพธ์ (category, total_sales):
--   กาแฟ | 5920000
--   เครื่องดื่มอื่น | 4326000
--   ขนม | 3339000
--   อาหาร | 3040000

-- Q6: ยอดขายแยกตามช่องทาง (JOIN 3 ตาราง)
SELECT o.channel, SUM(m.price * oi.quantity) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN menu m ON oi.item_id = m.item_id
GROUP BY o.channel
ORDER BY total_sales DESC;
-- ผลลัพธ์ (channel, total_sales):
--   หน้าร้าน | 12213000
--   เดลิเวอรี่ | 4412000

-- Q7: 3 ชั่วโมงที่มีบิลมากที่สุด (นับบิล ไม่ JOIN เพื่อกันนับซ้ำ)
SELECT strftime('%H', order_datetime) AS order_hour,
       COUNT(DISTINCT order_id) AS total_bills
FROM orders
GROUP BY order_hour
ORDER BY total_bills DESC
LIMIT 3;
-- ผลลัพธ์ (order_hour, total_bills):
--   08 | 60
--   12 | 49
--   15 | 41

-- Q8.1: เมนูขายดีที่สุดช่วงเช้า (ก่อน 11:00) ตามจำนวนชิ้น
SELECT m.item_name, SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN menu m ON oi.item_id = m.item_id
WHERE time(o.order_datetime) < '11:00:00'
GROUP BY m.item_id, m.item_name
ORDER BY total_quantity DESC
LIMIT 1;
-- ผลลัพธ์ (item_name, total_quantity):
--   กาแฟเย็นลาว | 38

-- Q8.2: เมนูขายดีที่สุดช่วงบ่าย (11:00 เป็นต้นไป) ตามจำนวนชิ้น
SELECT m.item_name, SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN menu m ON oi.item_id = m.item_id
WHERE time(o.order_datetime) >= '11:00:00'
GROUP BY m.item_id, m.item_name
ORDER BY total_quantity DESC
LIMIT 1;
-- ผลลัพธ์ (item_name, total_quantity):
--   แซนด์วิช | 59

-- Q9: ค่าเฉลี่ยยอดต่อบิล แยกตามช่องทาง (รวมยอดต่อบิลก่อนด้วย CTE)
WITH order_totals AS (
  SELECT o.order_id, o.channel,
         SUM(m.price * oi.quantity) AS bill_total
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN menu m ON oi.item_id = m.item_id
  GROUP BY o.order_id, o.channel
)
SELECT channel, ROUND(AVG(bill_total), 2) AS avg_ticket_size
FROM order_totals
GROUP BY channel;
-- ผลลัพธ์ (channel, avg_ticket_size):
--   หน้าร้าน | 48082.68
--   เดลิเวอรี่ | 49573.03

-- Q10: ยอดขายเฉลี่ยต่อวัน แยกตามวันในสัปดาห์ (หารด้วยจำนวนวันที่มีจริง)
SELECT CASE strftime('%w', o.order_datetime)
         WHEN '0' THEN 'อาทิตย์' WHEN '1' THEN 'จันทร์'
         WHEN '2' THEN 'อังคาร' WHEN '3' THEN 'พุธ'
         WHEN '4' THEN 'พฤหัสบดี' WHEN '5' THEN 'ศุกร์'
         WHEN '6' THEN 'เสาร์' END AS day_of_week,
       COUNT(DISTINCT date(o.order_datetime)) AS active_days,
       SUM(m.price * oi.quantity) AS total_sales,
       ROUND(SUM(m.price * oi.quantity) * 1.0
             / COUNT(DISTINCT date(o.order_datetime)), 2) AS avg_sales_per_day
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN menu m ON oi.item_id = m.item_id
GROUP BY strftime('%w', o.order_datetime), day_of_week
ORDER BY avg_sales_per_day DESC;
-- ผลลัพธ์ (day_of_week, active_days, total_sales, avg_sales_per_day):
--   เสาร์ | 2 | 2811000 | 1405500.0
--   อาทิตย์ | 2 | 2676000 | 1338000.0
--   จันทร์ | 2 | 1976000 | 988000.0
--   ศุกร์ | 3 | 2960000 | 986666.67
--   อังคาร | 2 | 1826000 | 913000.0
--   พุธ | 2 | 1778000 | 889000.0
--   พฤหัสบดี | 3 | 2598000 | 866000.0
