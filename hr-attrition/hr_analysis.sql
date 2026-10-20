-- HR ATTRITION ANALYSIS (HRDataset_v14, 311 พนักงาน)
-- รันหลัง hr_data_setup.sql | ตาราง: employees | เครื่องมือ: SQLite
-- หมายเหตุ: อัตราลาออกเป็นแบบสะสม 2006-2018 ไม่ใช่รายปี

-- Q0.1: ตรวจจำนวนแถวและ emp_id ซ้ำ
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT emp_id) AS unique_emp_id
FROM employees;
-- ผลลัพธ์ (total_rows, unique_emp_id):
--   311 | 311

-- Q0.2: ตรวจความยาวชื่อแผนก (พบช่องว่างต่อท้ายใน Production)
SELECT DISTINCT department, LENGTH(department) AS dept_length
FROM employees;
-- ผลลัพธ์ (department, dept_length):
--   Production        | 17
--   IT/IS | 5
--   Software Engineering | 20
--   Admin Offices | 13
--   Sales | 5
--   Executive Office | 16

-- Q0.3: ตรวจความยาวค่าเพศ (พบช่องว่างต่อท้ายใน 'M ')
SELECT DISTINCT sex, LENGTH(sex) AS sex_length
FROM employees;
-- ผลลัพธ์ (sex, sex_length):
--   M  | 2
--   F | 1

-- Q0.4: นับ Production โดยใช้ TRIM แก้ช่องว่าง
SELECT COUNT(*) AS production_count
FROM employees
WHERE TRIM(department) = 'Production';
-- ผลลัพธ์ (production_count):
--   209

-- Q1: จำนวนพนักงานแยกตามสถานะ
SELECT TRIM(employment_status) AS employment_status,
       COUNT(*) AS total_employees
FROM employees
GROUP BY TRIM(employment_status)
ORDER BY total_employees DESC;
-- ผลลัพธ์ (employment_status, total_employees):
--   Active | 207
--   Voluntarily Terminated | 88
--   Terminated for Cause | 16

-- Q2: จำนวนพนักงานแยกตามแผนก
SELECT TRIM(department) AS department, COUNT(*) AS total_employees
FROM employees
GROUP BY TRIM(department)
ORDER BY total_employees DESC;
-- ผลลัพธ์ (department, total_employees):
--   Production | 209
--   IT/IS | 50
--   Sales | 31
--   Software Engineering | 11
--   Admin Offices | 9
--   Executive Office | 1

-- Q3: เงินเดือนเฉลี่ย/ต่ำสุด/สูงสุด แยกตามแผนก
SELECT TRIM(department) AS department,
       ROUND(AVG(salary), 2) AS avg_salary,
       MIN(salary) AS min_salary,
       MAX(salary) AS max_salary
FROM employees
GROUP BY TRIM(department)
ORDER BY avg_salary DESC;
-- ผลลัพธ์ (department, avg_salary, min_salary, max_salary):
--   Executive Office | 250000.0 | 250000 | 250000
--   IT/IS | 97064.64 | 50178 | 220450
--   Software Engineering | 94989.45 | 77692 | 108987
--   Admin Offices | 71791.89 | 49920 | 106367
--   Sales | 69061.26 | 55875 | 180000
--   Production | 59953.55 | 45046 | 170500

-- Q4: 5 ตำแหน่งเงินเดือนเฉลี่ยสูงสุด (ทั้งห้าเป็นตำแหน่งที่มีคนเดียว จึงควรกรองกลุ่มเล็กเพิ่มด้วย HAVING)
SELECT TRIM(position) AS position,
       COUNT(*) AS employee_count,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY TRIM(position)
ORDER BY avg_salary DESC
LIMIT 5;
-- ผลลัพธ์ (position, employee_count, avg_salary):
--   President & CEO | 1 | 250000.0
--   CIO | 1 | 220450.0
--   Director of Sales | 1 | 180000.0
--   IT Director | 1 | 178000.0
--   Director of Operations | 1 | 170500.0

-- Q5: อัตราลาออกแยกตามแผนก (สะสม 2006-2018)
SELECT TRIM(department) AS department,
       COUNT(*) AS total_employees,
       SUM(termd) AS terminated_employees,
       ROUND(AVG(termd) * 100.0, 1) AS turnover_rate_pct
FROM employees
GROUP BY TRIM(department)
ORDER BY turnover_rate_pct DESC;
-- ผลลัพธ์ (department, total_employees, terminated_employees, turnover_rate_pct):
--   Production | 209 | 83 | 39.7
--   Software Engineering | 11 | 4 | 36.4
--   Admin Offices | 9 | 2 | 22.2
--   IT/IS | 50 | 10 | 20.0
--   Sales | 31 | 5 | 16.1
--   Executive Office | 1 | 0 | 0.0

-- Q6: อัตราลาออกแยกตามแหล่งสรรหา (เฉพาะกลุ่ม 20 คนขึ้นไป)
SELECT TRIM(recruitment_source) AS recruitment_source,
       COUNT(*) AS total_employees,
       SUM(termd) AS terminated_employees,
       ROUND(AVG(termd) * 100.0, 1) AS turnover_rate_pct
FROM employees
GROUP BY TRIM(recruitment_source)
HAVING COUNT(*) >= 20
ORDER BY turnover_rate_pct DESC;
-- ผลลัพธ์ (recruitment_source, total_employees, terminated_employees, turnover_rate_pct):
--   Google Search | 49 | 30 | 61.2
--   Diversity Job Fair | 29 | 16 | 55.2
--   CareerBuilder | 23 | 11 | 47.8
--   Indeed | 87 | 21 | 24.1
--   LinkedIn | 76 | 18 | 23.7
--   Employee Referral | 31 | 5 | 16.1

-- Q6b: แผนก x แหล่งสรรหา (ตรวจ confounding)
SELECT TRIM(department) AS department,
       TRIM(recruitment_source) AS recruitment_source,
       COUNT(*) AS total_employees,
       SUM(termd) AS terminated_employees,
       ROUND(AVG(termd) * 100.0, 1) AS turnover_rate_pct
FROM employees
GROUP BY TRIM(department), TRIM(recruitment_source)
ORDER BY department, recruitment_source;
-- ผลลัพธ์ (department, recruitment_source, total_employees, terminated_employees, turnover_rate_pct):
--   Admin Offices | CareerBuilder | 1 | 0 | 0.0
--   Admin Offices | Diversity Job Fair | 3 | 1 | 33.3
--   Admin Offices | Indeed | 2 | 1 | 50.0
--   Admin Offices | Other | 1 | 0 | 0.0
--   Admin Offices | Website | 2 | 0 | 0.0
--   Executive Office | Indeed | 1 | 0 | 0.0
--   IT/IS | CareerBuilder | 2 | 1 | 50.0
--   IT/IS | Diversity Job Fair | 4 | 1 | 25.0
--   IT/IS | Employee Referral | 13 | 2 | 15.4
--   IT/IS | Google Search | 1 | 1 | 100.0
--   IT/IS | Indeed | 19 | 2 | 10.5
--   IT/IS | LinkedIn | 11 | 3 | 27.3
--   Production | CareerBuilder | 16 | 9 | 56.3
--   Production | Diversity Job Fair | 17 | 11 | 64.7
--   ... อีก 19 แถว

-- Q7: 5 เหตุผลลาออกที่พบบ่อยที่สุด (ฐาน = ผู้ที่ออก 104 คน)
SELECT TRIM(term_reason) AS term_reason,
       COUNT(*) AS count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees WHERE termd = 1), 2) AS percentage
FROM employees
WHERE termd = 1 AND TRIM(term_reason) <> 'N/A-StillEmployed'
GROUP BY TRIM(term_reason)
ORDER BY count DESC
LIMIT 5;
-- ผลลัพธ์ (term_reason, count, percentage):
--   Another position | 20 | 19.23
--   unhappy | 14 | 13.46
--   more money | 11 | 10.58
--   career change | 9 | 8.65
--   hours | 8 | 7.69

-- Q8: อายุงานเฉลี่ยของผู้ที่ลาออก (ปี)
SELECT ROUND(AVG((julianday(term_date) - julianday(hire_date)) / 365.25), 2) AS avg_tenure_years
FROM employees
WHERE termd = 1 AND term_date IS NOT NULL;
-- ผลลัพธ์ (avg_tenure_years):
--   3.46

-- Q9: เทียบ engagement, satisfaction, absences ตามสถานะ
SELECT TRIM(employment_status) AS employment_status,
       COUNT(*) AS total_employees,
       ROUND(AVG(engagement_score), 2) AS avg_engagement,
       ROUND(AVG(satisfaction), 2) AS avg_satisfaction,
       ROUND(AVG(absences), 2) AS avg_absences
FROM employees
GROUP BY TRIM(employment_status)
ORDER BY total_employees DESC;
-- ผลลัพธ์ (employment_status, total_employees, avg_engagement, avg_satisfaction, avg_absences):
--   Active | 207 | 4.12 | 3.89 | 9.83
--   Voluntarily Terminated | 88 | 4.18 | 3.9 | 10.95
--   Terminated for Cause | 16 | 3.6 | 3.81 | 11.56

-- Q10: อัตราลาออกของทีมผู้จัดการ (ดูแล 10 คนขึ้นไป)
SELECT TRIM(manager_name) AS manager_name,
       COUNT(*) AS total_managed,
       SUM(termd) AS total_terminated,
       ROUND(AVG(termd) * 100.0, 1) AS turnover_rate_pct
FROM employees
GROUP BY TRIM(manager_name)
HAVING COUNT(*) >= 10
ORDER BY turnover_rate_pct DESC;
-- ผลลัพธ์ (manager_name, total_managed, total_terminated, turnover_rate_pct):
--   Webster Butler | 21 | 13 | 61.9
--   Amy Dunn | 21 | 13 | 61.9
--   Kissy Sullivan | 22 | 12 | 54.5
--   Simon Roup | 17 | 8 | 47.1
--   Michael Albert | 22 | 9 | 40.9
--   Elijiah Gray | 22 | 8 | 36.4
--   Janet King | 19 | 6 | 31.6
--   David Stanley | 21 | 6 | 28.6
--   Kelley Spirea | 22 | 6 | 27.3
--   Brannon Miller | 22 | 6 | 27.3
--   Ketsia Liebig | 21 | 5 | 23.8
--   John Smith | 14 | 3 | 21.4
--   Lynn Daneault | 13 | 1 | 7.7
--   Peter Monroe | 14 | 1 | 7.1

-- Q11a: เงินเดือนเฉลี่ยแยกตามเพศ (ภาพรวม)
SELECT TRIM(sex) AS sex,
       COUNT(*) AS employee_count,
       ROUND(AVG(salary), 2) AS avg_salary,
       MIN(salary) AS min_salary,
       MAX(salary) AS max_salary
FROM employees
GROUP BY TRIM(sex);
-- ผลลัพธ์ (sex, employee_count, avg_salary, min_salary, max_salary):
--   F | 176 | 67786.73 | 45046 | 250000
--   M | 135 | 70629.4 | 45115 | 178000

-- Q11b: เงินเดือนเฉลี่ยในตำแหน่งเดียวกัน แยกตามเพศ (ระวังกลุ่มเล็ก)
SELECT TRIM(position) AS position, TRIM(sex) AS sex,
       COUNT(*) AS employee_count,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY TRIM(position), TRIM(sex)
ORDER BY position, sex;
-- ผลลัพธ์ (position, sex, employee_count, avg_salary):
--   Accountant I | F | 1 | 63000.0
--   Accountant I | M | 2 | 63761.5
--   Administrative Assistant | F | 3 | 52280.0
--   Area Sales Manager | F | 12 | 63793.5
--   Area Sales Manager | M | 15 | 65843.8
--   BI Developer | F | 1 | 95920.0
--   BI Developer | M | 3 | 95313.33
--   BI Director | M | 1 | 110929.0
--   CIO | F | 1 | 220450.0
--   Data Analyst | F | 3 | 90909.67
--   Data Analyst | M | 5 | 89065.2
--   Data Architect | F | 1 | 150290.0
--   Database Administrator | F | 4 | 107124.75
--   Database Administrator | M | 1 | 113999.0
--   ... อีก 32 แถว
