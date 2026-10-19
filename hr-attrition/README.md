# HR Attrition Analysis

## โจทย์ (Problem Statement)

วิเคราะห์อัตราการลาออกของพนักงานในองค์กร เพื่อระบุปัจจัยสำคัญที่ส่งผลต่อการลาออกและเสนอแนวทางในการรักษาพนักงานไว้กับองค์กร

## ข้อมูล (Data)

- **ที่มา:** [IBM HR Analytics Employee Attrition & Performance Dataset](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset) จาก Kaggle
- **ลักษณะข้อมูล:** ข้อมูลสมมติ (Synthetic dataset) สำหรับการฝึกวิเคราะห์
- **จำนวนรายการ:** 311 พนักงาน (จากชุดข้อมูลที่ใช้ในโปรเจกต์นี้)
- **ฟิลด์สำคัญ:** emp_id, department, position, hire_date, hire_year, term_date, employment_status, left_flag, salary, recruitment_source, performance_score, engagement_score, satisfaction, absences, tenure_years

## เครื่องมือที่ใช้ (Tools)

- SQL - สำหรับการจัดเตรียมและวิเคราะห์ข้อมูล
- Python (pandas, matplotlib) - สำหรับการวิเคราะห์เชิงลึกและสร้างกราฟ
- Looker Studio - สำหรับการสร้างแดชบอร์ดเชิงโต้ตอบ

## ไฟล์ในโฟลเดอร์ (Files)

- `hr.ipynb` - Notebook Python สำหรับการวิเคราะห์ข้อมูล
- `hr_dashboard.csv` - ไฟล์ข้อมูลที่ใช้สำหรับการวิเคราะห์
- `turnover_by_hireyear.png` - กราฟแสดงอัตราการลาออกแบ่งตามปีที่จ้าง
- `hr_data_setup.sql` - สคริปต์ SQL สำหรับเตรียมข้อมูล

## ข้อค้นพบ (Key Findings)

1. **อัตราการลาออกรวมสูง** - จากพนักงานทั้งหมด 311 คน มี 104 คนลาออก คิดเป็น 33.4%
2. **พนักงานรุ่นปี 2011 มีอัตราการลาออกสูงมาก** - พนักงานที่จ้างในปี 2011 จำนวน 83 คน ลาออก 59 คน คิดเป็น 71.1% ขณะที่พนักงานที่จ้างในปีอื่นๆ (228 คน) ลาออกเพียง 19.7%
3. **แผนก Production มีอัตราการลาออกสูงสุด** - แผนก Production มีอัตราการลาออก 39.7% (83 จาก 209 คน) ตามด้วย Software Engineering 36.4% (4 จาก 11 คน)

## ข้อจำกัด (Limitations)

- ชุดข้อมูลนี้เป็นข้อมูลสมมติเพื่อการฝึกฝน ไม่ได้มาจากองค์กรจริง
- การวิเคราะห์เป็นการสำรวจเชิงพรรณนา (Exploratory) จึงไม่สามารถสรุปความสัมพันธ์เชิงเหตุและผลได้ทั้งหมด
- มีข้อมูลบางฟิลด์ไม่สมบูรณ์สำหรับพนักงานที่ยังทำงานอยู่

## ลิงก์ (Links)

- [แดชบอร์ด Looker Studio](https://public.tableau.com/app/profile/nynon/viz/hr-attrition-dashboard) - แดชบอร์ดแสดงผลการวิเคราะห์แบบโต้ตอบ
- [เอกสารโครงการบน Notion](https://app.notion.com/p/SQL-HR-Analytics-3fcea3e865eb81538c91c84a3f0c2d0d) - รายละเอียดขั้นตอนการวิเคราะห์และข้อสรุป
