# Sales Data Pipeline

## 📌 Project Overview
This project demonstrates an end-to-end data workflow designed to ingest, process, and analyze retail transaction logs. The pipeline covers programmatic data extraction, multi-stage cleaning and data hygiene validation using Python, structured relational persistence inside a MySQL database, and final business intelligence reporting via Power BI.

* **⚙️ Tech Stack:** Python (Pandas, SQLAlchemy, PyMySQL), MySQL, Power BI

---

### ✅ Dataset Constraints & Structure
* **Core Dimensions:** OrderID, Order Date, Segment, Ship Mode, Category, Sub-Category
* **Geographic Tiers:** Country, State, City, Region
* **Financial Attributes:** Discount, Sales, Profit
* **Sample Volumetrics:** ~8,037 rows

---

### 📌 Workflow

#### 1️⃣ Data Ingestion & Exploration
* Loaded raw source matrices into the runtime using Pandas (`read_csv`).
* Evaluated data boundaries and array profiling through structural and descriptive methods (`.shape`, `.info()`, `.describe()`, `.unique()`).

#### 2️⃣ Programmatic Data Cleaning & Quality Assurance
* Isolated and eliminated incomplete null sets and exact transactional duplicates to prevent double-counting.
* Evaluated records for upstream system errors by auditing core logical contradictions:
  * Negative absolute values for sales transactions.
  * Disconnected promotional anomalies (discounts scaling above 100%).
* Verified structural data types, converting timestamp text to native datetimes, numerical data to floats, and low-cardinality values to categories.
* Sanitized and normalized string text padding to ensure categorical consistency across charts.

#### 3️⃣ Feature Engineering & Transformation
* Extracted isolated temporal dimensions (`Year`, `Month`) from the order timeline to optimize down-stream time-series calculations.
* Validated `OrderID` structural boundaries and committed the refined dataframe array.

#### 4️⃣ Database Modeling & Persistence
* Orchestrated data table migration to a local MySQL instance using an engine connection pool managed by SQLAlchemy and PyMySQL.
* Enforced an organized destination schema (`cleaned_orders`) with explicit variable datatypes optimized for rapid relational aggregation.

#### 5️⃣ Business Intelligence Reporting & KPI Analysis
The relational backend database table was connected directly to the dashboard visualization layer to calculate and present high-impact performance grids:

* **Financial Performance Baselines:** Summary KPI arrays calculate absolute operational health at a single glance, highlighting **$2M in Total Sales**, **$283K in Total Net Profit**, **30K Units Sold**, and a steady **12% average Profit Margin**.
* **Promotion & Margin Stability Analysis:** Evaluated promotional business impact by mapping discount variables against net unit margins, identifying distinct pricing thresholds where excessive discount rates began directly eroding profits.
* **Market Demographics & Logistical Segmentation:** Segmented operational volumes across customer types (Consumer, Corporate, Home Office), item lines (Technology, Office Supplies, Furniture), and international boundaries—explicitly isolating dominant profit centers like the United Kingdom and Germany.

<img width="1269" height="715" alt="image" src="https://github.com/user-attachments/assets/b2f76274-74a3-42c2-b627-49153917a208" />

