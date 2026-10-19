-- HR ATTRITION ANALYSIS
-- Data: IBM HR Analytics Employee Attrition & Performance Dataset (Kaggle) - Synthetic data
-- Tool: SQL

-- Q1: จำนวนพนักงานทั้งหมด
-- ผล: Total employees
SELECT 
  COUNT(*) AS total_employees
FROM hr_data;

-- Q2: อัตราการลาออกโดยรวม
-- ผล: Overall attrition rate = 104/311 = 33.44%
SELECT 
  SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) AS left_count,
  COUNT(*) AS total_employees,
  ROUND(SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_data;

-- Q3: อัตราการลาออกแยกตามแผนก
-- ผล: Attrition rate by department
SELECT 
  department,
  COUNT(*) AS total,
  SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) AS left_count,
  ROUND(SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_data
GROUP BY department
ORDER BY attrition_rate_pct DESC;

-- Q4: อัตราการลาออกแยกตามปีที่จ้าง
-- ผล: Attrition rate by hire year - 2011 stands out (71.08%)
SELECT 
  hire_year,
  COUNT(*) AS total_hired,
  SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) AS left_count,
  ROUND(SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_data
GROUP BY hire_year
ORDER BY hire_year;

-- Q5: เปรียบเทียบกลุ่มปี 2011 กับกลุ่มอื่น
-- ผล: 2011 cohort: 83 hired, 59 left (71.08%) vs others: 228 hired, 45 left (19.74%)
SELECT 
  CASE 
    WHEN hire_year = 2011 THEN 'Cohort_2011'
    ELSE 'Others'
  END AS group,
  COUNT(*) AS total,
  SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) AS left_count,
  ROUND(SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_data
GROUP BY group;

-- Q6: ค่าเฉลี่ยอายุงาน (Tenure) ของพนักงานที่ลาออก vs ยังทำงานอยู่
-- ผล: Avg tenure - Left: ~3.46 years, Active: varies
SELECT 
  CASE WHEN left_flag = 1 THEN 'Left' ELSE 'Active' END AS status,
  ROUND(AVG(tenure_years), 2) AS avg_tenure_years,
  COUNT(*) AS count
FROM hr_data
WHERE tenure_years IS NOT NULL
GROUP BY status;

-- Q7: ค่าเฉลี่ยการขาดงาน
-- ผล: Avg absences comparison
SELECT 
  CASE WHEN left_flag = 1 THEN 'Left' ELSE 'Active' END AS status,
  ROUND(AVG(absences), 2) AS avg_absences
FROM hr_data
WHERE absences IS NOT NULL
GROUP BY status;

-- Q8: คะแนนความพึงพอใจ
-- ผล: Satisfaction scores comparison
SELECT 
  CASE WHEN left_flag = 1 THEN 'Left' ELSE 'Active' END AS status,
  ROUND(AVG(satisfaction), 2) AS avg_satisfaction
FROM hr_data
WHERE satisfaction IS NOT NULL
GROUP BY status;

-- Q9: แหล่งการสรรหาที่มีอัตราการลาออกสูง
-- ผล: Recruitment source attrition analysis
SELECT 
  recruitment_source,
  COUNT(*) AS total,
  SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) AS left_count,
  ROUND(SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_data
WHERE recruitment_source IS NOT NULL
GROUP BY recruitment_source
ORDER BY attrition_rate_pct DESC;

-- Q10: อัตราการลาออกตามตำแหน่งงาน (Top positions with highest attrition)
-- ผล: Position-wise attrition
SELECT 
  position,
  COUNT(*) AS total,
  SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) AS left_count,
  ROUND(SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_data
GROUP BY position
HAVING COUNT(*) >= 5
ORDER BY attrition_rate_pct DESC;

-- Q11: สรุปภาพรวม Production vs อื่นๆ
-- ผล: Focus on highest risk department
SELECT 
  CASE WHEN department = 'Production' THEN 'Production' ELSE 'Other Departments' END AS group,
  COUNT(*) AS total,
  SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) AS left_count,
  ROUND(SUM(CASE WHEN left_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_data
GROUP BY group;
