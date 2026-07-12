<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Fira+Code:wght@400;500&display=swap');

* { box-sizing: border-box; }

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    line-height: 1.75;
    color: #1e293b;
    max-width: 900px;
    margin: 0 auto;
    padding: 40px 36px;
    background: #ffffff;
}

h1 {
    font-size: 2.4em;
    font-weight: 700;
    color: #0f172a;
    text-align: center;
    border-bottom: 4px solid #1a4f9c;
    padding-bottom: 14px;
    margin-bottom: 6px;
    letter-spacing: -0.5px;
}
h2 {
    font-size: 1.55em;
    font-weight: 700;
    color: #1a4f9c;
    border-left: 5px solid #1a4f9c;
    padding-left: 14px;
    margin-top: 48px;
    margin-bottom: 16px;
}
h3 {
    font-size: 1.15em;
    font-weight: 600;
    color: #1e293b;
    margin-top: 28px;
    margin-bottom: 10px;
}
h4 {
    font-size: 1em;
    font-weight: 600;
    color: #475569;
    text-transform: uppercase;
    letter-spacing: 0.6px;
    margin-top: 20px;
    margin-bottom: 8px;
}

hr {
    border: none;
    border-top: 1px solid #e2e8f0;
    margin: 40px 0;
}

code {
    font-family: 'Fira Code', 'SFMono-Regular', Consolas, monospace;
    background: #f1f5f9;
    color: #be185d;
    padding: 2px 7px;
    border-radius: 5px;
    font-size: 0.875em;
}

pre {
    background: #0f172a;
    color: #e2e8f0;
    border-radius: 10px;
    padding: 22px 24px;
    overflow-x: auto;
    margin: 18px 0;
    border-left: 4px solid #1a4f9c;
    box-shadow: 0 4px 14px rgba(0,0,0,0.15);
    page-break-inside: avoid;
}
pre code {
    background: transparent;
    color: #e2e8f0;
    padding: 0;
    font-size: 0.83em;
    line-height: 1.7;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin: 24px 0;
    font-size: 0.93em;
    page-break-inside: avoid;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 1px 6px rgba(0,0,0,0.07);
}
thead tr {
    background: #1a4f9c;
    color: #ffffff;
}
th {
    padding: 13px 16px;
    font-weight: 600;
    text-align: left;
    letter-spacing: 0.3px;
}
td {
    padding: 11px 16px;
    border-bottom: 1px solid #e2e8f0;
    color: #334155;
}
tr:nth-child(even) td { background: #f8fafc; }
tr:last-child td { border-bottom: none; }

blockquote {
    margin: 24px 0;
    padding: 16px 20px;
    border-left: 5px solid #1a4f9c;
    background: #eff6ff;
    border-radius: 0 8px 8px 0;
    color: #1e40af;
    font-style: normal;
    page-break-inside: avoid;
}

ul, ol { padding-left: 24px; margin: 10px 0; }
li { margin-bottom: 6px; }
li strong { color: #1e293b; }

pre, table, blockquote { page-break-inside: avoid; }
h2, h3 { page-break-after: avoid; }
</style>

---

# 📊 Sales Performance Analytics

> An end-to-end Business Intelligence & Data Engineering project — raw retail data transformed into a normalized MySQL database, 30 SQL analytics queries, and an interactive Power BI dashboard.

**Stack:** MySQL 8.0+ · Python (Pandas) · SQL · Power BI Desktop · Git

---

## 🔍 Project Overview

Transactional data in corporate environments is often stored in wide, flat CSV files — bloated with redundancy and impossible to query efficiently. This project solves that with a complete **ETL pipeline** followed by deep analytics and visual intelligence on the classic **Superstore Sales Dataset (2014–2017, ~9,994 rows)**.

---

## 🛠 Tech Stack

| Layer | Technology | Role |
| :--- | :--- | :--- |
| **Database** | MySQL 8.0+ | Schema design, constraint enforcement, query execution |
| **ETL & Preprocessing** | Python (Pandas) | Text stripping, date formatting, duplicate removal |
| **Analytics** | SQL (30 Queries) | Window functions, CTEs, LAG, aggregations, subqueries |
| **Visualization** | Power BI Desktop | Star schema modeling, DAX measures, interactive dashboards |
| **Version Control** | Git / GitHub | Commit history, portfolio deployment |

---

## ⚙️ Pipeline Architecture

```text
  [EXTRACT]         [TRANSFORM]         [LOAD]              [ANALYZE]         [VISUALIZE]
  Raw CSV/Excel  →  Python/Pandas    →  MySQL Staging    →  30 SQL Queries →  Power BI
                    Strip/Format        → Normalized                           Dashboards
```

**Stage 1 · Extract** — Bulk load CSV into MySQL staging table using `LOAD DATA LOCAL INFILE` (100× faster than row-by-row INSERT).

**Stage 2 · Transform** — Python/Pandas handles three pre-load fixes:
- `.str.strip()` on all ID columns (trailing spaces broke joins silently)
- Date strings converted using `STR_TO_DATE(col, '%Y-%m-%d')`
- Fully duplicate rows removed

**Stage 3 · Load** — SQL ETL scripts migrate staging rows into the normalized Star Schema.

**Stage 4 · Analyze** — 30 business queries extract KPIs, trends, rankings, and segment insights.

**Stage 5 · Visualize** — Power BI connects to the MySQL schema and renders an interactive dashboard.

---

## 🗄 Database Schema Design

### Normalization: Flat File → Star Schema (3NF)

The raw `superstore_raw` table suffered from the classic three database anomalies:
- **Insertion Anomaly** — Cannot add a new customer without a purchase.
- **Update Anomaly** — Changing a product name requires updating thousands of rows.
- **Deletion Anomaly** — Deleting an order erases the customer's only profile.

**Solution:** Split into 4 Dimension Tables + 1 Fact Table following 3NF.

### Table Catalog

| Table | Type | Primary Key | Duplicates Policy |
| :--- | :--- | :--- | :--- |
| `customers` | Dimension | `customer_id` — Unique | `customer_name`, `segment` allow duplicates |
| `products` | Dimension | `product_id` — Unique | `product_name`, `category`, `sub_category` allow duplicates |
| `regions` | Dimension | `region_id` — Auto-increment | All geography columns allow duplicates |
| `orders` | Dimension | `order_id` — Unique | `customer_id` FK, `region_id` FK allow duplicates |
| `sales` | **Fact** | `(order_id, product_id)` — Composite PK | Each column individually allows duplicates |

### Entity Relationship Diagram

```text
  customers ──(1:N)──▶ orders ──(1:N)──▶ sales (Fact) ◀──(1:N)── products
  regions   ──(1:N)──▶ orders
```

```text
  ┌──────────────────┐           ┌──────────────────┐
  │    customers     │           │     regions       │
  ├──────────────────┤           ├──────────────────┤
  │ PK customer_id   │           │ PK region_id      │
  │    customer_name │           │    country        │
  │    segment       │           │    region         │
  └────────┬─────────┘           │    state          │
           │ 1:N                 │    city           │
           │                     │    postal_code    │
  ┌────────▼─────────────────────┤                   │
  │          orders              │ 1:N               │
  ├──────────────────────────────┘                   │
  │ PK order_id                  ◀───────────────────┘
  │    order_date, ship_date
  │    ship_mode
  │ FK customer_id, region_id
  └────────┬─────────┐
           │ 1:N     │
  ┌────────▼───────────────────┐   ┌──────────────────┐
  │      sales (Fact)          │   │     products      │
  ├────────────────────────────┤   ├──────────────────┤
  │ PK,FK order_id             │   │ PK product_id     │
  │ PK,FK product_id ◀─────────┤1:N│    product_name   │
  │       sales                │   │    category       │
  │       quantity             │   │    sub_category   │
  │       discount, profit     │   └──────────────────┘
  └────────────────────────────┘
```

---

## 💻 SQL Business Analytics (30 Queries)

| Tier | Queries | Focus Area |
| :--- | :---: | :--- |
| Financial KPIs | 1–5 | Revenue, profit, AOV, margin % |
| Category & Products | 6–10 | Sales by category, top 10 products |
| Anomaly & Customers | 11–15 | Loss-makers, top customers, segment splits |
| Temporal Trends | 16–20 | Monthly/yearly performance |
| Geography & Discounts | 21–25 | Region/state/city breakdowns |
| Advanced Analytics | 26–30 | Window functions, CTEs, LAG, running totals |

### Sample: Top Product Per Category

```sql
WITH product_sales AS (
    SELECT p.category, p.product_name,
           ROUND(SUM(s.sales), 2) AS total_sales,
           DENSE_RANK() OVER (PARTITION BY p.category
                              ORDER BY SUM(s.sales) DESC) AS rnk
    FROM products p JOIN sales s ON p.product_id = s.product_id
    GROUP BY p.category, p.product_id, p.product_name
)
SELECT category, product_name, total_sales
FROM   product_sales WHERE rnk = 1;
```

### Sample: Month-over-Month Growth

```sql
WITH monthly AS (
    SELECT YEAR(o.order_date) yr, MONTH(o.order_date) mo,
           ROUND(SUM(s.sales), 2) total_sales
    FROM orders o JOIN sales s ON o.order_id = s.order_id
    GROUP BY yr, mo
)
SELECT yr, mo, total_sales,
       LAG(total_sales) OVER (ORDER BY yr, mo)                        prev_sales,
       ROUND(total_sales - LAG(total_sales) OVER (ORDER BY yr, mo),2) mom_diff
FROM monthly ORDER BY yr, mo;
```

---

## 📊 Power BI Model & Dashboard

### DAX Measures

| Measure | Formula |
| :--- | :--- |
| `Total Sales` | `SUM(sales[sales])` |
| `Total Profit` | `SUM(sales[profit])` |
| `Total Orders` | `DISTINCTCOUNT(sales[order_id])` |
| `Profit Margin %` | `DIVIDE([Total Profit], [Total Sales], 0) * 100` |
| `Average Order Value` | `DIVIDE([Total Sales], [Total Orders], 0)` |

> **Note:** `DIVIDE` is used instead of `/` to safely return `0` when the denominator is zero — preventing dashboard visual crashes when filters reduce data to empty sets.

### Dashboard Preview

![Power BI Sales Dashboard](../Images/Dashboard/DASHBOARD.png)

### Data Model

![Power BI Data Model](../Images/Model/MODEL.png)

---

## 💡 Business Insights

| # | Finding | Action |
| :--- | :--- | :--- |
| 1 | Technology has the highest profit margin (~17%) | Prioritize upselling tech bundles |
| 2 | Furniture matches Technology in revenue but returns near-zero profit | Cap discounts at 15%; renegotiate shipping rates |
| 3 | West + East = 66% of total revenue | Focus marketing spend in California and New York |
| 4 | Consumer segment = 50%+ of transactions | Expand B2B Corporate outreach |
| 5 | Standard Class = 60%+ of all deliveries | Target bulk freight negotiations at standard carriers |

---

## 🚨 Engineering Challenges & Solutions

### 1. Silent Join Failures — Whitespace in IDs
- **Problem:** Trailing spaces in `customer_id`/`product_id` strings caused joins to silently return zero rows.
- **Solution:** Python `.str.strip()` on all ID columns before CSV export.

### 2. Product Spelling Conflicts — PK Violations
- **Problem:** One `product_id` mapped to multiple name spellings over time → `SELECT DISTINCT` returned duplicate keys.
- **Solution:** `GROUP BY product_id` + `MIN(product_name)` to canonicalize one name per ID.

### 3. Composite Key Duplicates in `sales`
- **Problem:** Buying the same product twice in one order → duplicate `(order_id, product_id)` pairs.
- **Solution:** Aggregate with `SUM(sales)`, `SUM(quantity)`, `AVG(discount)`, `SUM(profit)`.

### 4. Many-to-Many Ambiguity in Power BI
- **Problem:** Multiple join paths between tables created circular dependencies.
- **Solution:** Strict Star Schema — all relationships flow one-way from dimensions to the fact table.

---

## 📂 Project Structure

```text
Sales-Performance-Analytics/
├── Dataset/
│   └── Superstore_Clean.csv
├── Documentation/
│   ├── Project_Summary.md                  ← This document
│   └── SQL_Interview_Preparation_Guide.md
├── Images/
│   ├── Dashboard/DASHBOARD.png
│   └── Model/MODEL.png
├── PowerBI/
│   └── SQL_PROJ_backup.pbix
├── SQL/
│   ├── 00_create_database.sql
│   ├── 01_schema_creation.sql
│   ├── 02_data_loading.sql
│   ├── 03_ETL_normalization.sql
│   ├── 04_data_validation.sql
│   └── 05_bussiness_analytics.sql
└── README.md
```

---

## ⚙️ Setup & Execution

```bash
git clone https://github.com/chidvi123/sales-performance-analytics.git
cd sales-performance-analytics
```

Run SQL scripts in order in MySQL Workbench:

```text
1. 00_create_database.sql      → Create database catalog
2. 01_schema_creation.sql      → Build all table schemas
3. 02_data_loading.sql         → Load CSV into staging table
4. 03_ETL_normalization.sql    → Migrate into normalized schema
5. 04_data_validation.sql      → Verify row counts
6. 05_bussiness_analytics.sql  → Run all 30 business queries
```

Open `PowerBI/SQL_PROJ_backup.pbix` in Power BI Desktop to explore the dashboard.

---

## 📈 Key Learnings

- Designed a 3NF schema from a single flat file eliminating all three classic DB anomalies.
- Built a staging-table-based ETL pipeline using `LOAD DATA INFILE`, `STR_TO_DATE`, `MIN()`, and composite `GROUP BY`.
- Used `DENSE_RANK()`, `LAG()`, `SUM() OVER()`, and CTEs for advanced SQL analytics.
- Designed a clean Power BI Star Schema with explicit DAX measures and single-direction filter flow.

---

## 🔮 Future Enhancements

- **Apache Airflow** — Automate and schedule daily ETL runs.
- **Snowflake / BigQuery** — Migrate to cloud-based columnar warehouse for scale.
- **dbt** — Modularize transformations, add data lineage, and enforce automated quality tests.

---

## 👤 Author

**Chidvilas** — [github.com/chidvi123](https://github.com/chidvi123)

*MIT License · Built with MySQL, Python, Power BI, and SQL.*
