# 📊 Sales Performance Analytics Dashboard

[![MySQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Power BI](https://img.shields.io/badge/Power_BI-Desktop-F2C811?style=flat-square&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![Pandas](https://img.shields.io/badge/Pandas-1.5+-150458?style=flat-square&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![Git](https://img.shields.io/badge/Git-VCS-F05032?style=flat-square&logo=git&logoColor=white)](https://git-scm.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](https://opensource.org/licenses/MIT)

An end-to-end Business Intelligence and Data Engineering project demonstrating the transformation of raw, denormalized corporate retail transactional data into a fully normalized, high-performance relational database (MySQL), followed by deep SQL analytics and interactive visual intelligence in Power BI.

---

## 📌 Table of Contents
1. [Project Overview](#-project-overview)
2. [Key Features](#-key-features)
3. [Tech Stack](#-tech-stack)
4. [Dataset Information](#-dataset-information)
5. [Database Design & ERD](#-database-design--erd)
6. [Normalization Journey (1NF → 3NF)](#-normalization-journey-1nf--3nf)
7. [ETL Pipeline Architecture](#-etl-pipeline-architecture)
8. [SQL Business Analytics](#-sql-business-analytics)
9. [Power BI Data Modeling & Dashboards](#-power-bi-data-modeling--dashboards)
10. [Dashboard Insights](#-dashboard-insights)
11. [Project Structure](#-project-structure)
12. [Installation & Execution Guide](#-installation--execution-guide)
13. [Key Learning Outcomes](#-key-learning-outcomes)
14. [Future Scalability Enhancements](#-future-scalability-enhancements)
15. [Author](#-author)
16. [License](#-license)

---

## 🔍 Project Overview
In modern enterprise environments, transactional data is frequently stored in flat sheets or wide, denormalized staging formats. This project implements a complete pipeline to ingest raw sales data, clean and structure it programmatically, establish a normalized relational schema, execute complex analytical queries to resolve core business questions, and build a dashboard that tracks operational and financial performance.

---

## 🚀 Key Features
*   **Programmatic Preprocessing:** Automated data scrubbing, schema validation, and date formatting using Python and Pandas.
*   **Normalized Database Architecture:** Redundancy-free design moving from a single wide table to a highly structured 3NF star-like relational model.
*   **Analytical Depth:** A comprehensive SQL suite of 30 advanced business queries covering performance, growth, margins, trends, and segment behaviors.
*   **Interactive BI Interface:** Dynamic Power BI visualizations with customized DAX measures, filtering slicers, and performance trackers.

---

## 🛠 Tech Stack
| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Database Engine** | MySQL 8.0+ | Relational storage, schema constraint enforcement, and query execution. |
| **ETL & Data Prep** | Python (Pandas) | Raw dataset cleaning, text trim operations, and CSV standardization. |
| **Analytics Engine** | SQL | Normalization scripts, analytical windows, subqueries, and table joins. |
| **Data Visualization** | Power BI Desktop | Data modeling, star-schema layout, and interactive dashboard reports. |
| **Version Control** | Git / GitHub | Project tracking, version history, and portfolio deployment. |

---

## 📅 Dataset Information
The project utilizes the classic **Sample Superstore Dataset** (covering sales transactions from 2014 to 2017).
*   **Format:** Excel / Cleaned CSV
*   **Volume:** ~9,994 transaction rows
*   **Attributes:** Transaction ID, Order Date, Shipping Date, Customer Details (Segment, Name), Product Catalog (Category, Sub-Category, Name), Geographics (Region, State, City, Postal Code), and Financial Metrics (Sales, Quantity, Discount, Profit).

---

## 🗄 Database Design & ERD
The original database model consisted of a single wide table (`superstore_raw`) containing duplicate information for customers, products, and locations on every single order line item. 

To eliminate insertion, update, and deletion anomalies, the schema was broken down into **4 Dimension Tables** and **1 Fact Table** (`sales`).

### Entity-Relationship Diagram (ERD)

![Database ERD Schema](Images/Model/MODEL.png)

<details>
<summary>📐 View Schema ASCII Diagram Representation</summary>

```text
          +-------------------+             +-------------------+
          |     customers     |             |      regions      |
          +-------------------+             +-------------------+
          | PK | customer_id  |             | PK | region_id    |
          |    | customer_name|             |    | country      |
          |    | segment      |             |    | region       |
          +----------+--------+             |    | state        |
                     |                      |    | city         |
                     | 1                    |    | postal_code  |
                     |                      +----------+--------+
                     |                                 |
                     | M                               | 1
          +----------v--------+                        |
          |      orders       <------------------------+ M
          +-------------------+
          | PK | order_id     |
          |    | order_date   |             +-------------------+
          |    | ship_date    |             |     products      |
          |    | ship_mode    |             +-------------------+
          | FK | customer_id  |             | PK | product_id   |
          | FK | region_id    |             |    | product_name |
          +----------+--------+             |    | category     |
                     |                      |    | sub_category |
                     | 1                    +----------+--------+
                     |                                 |
                     | M                               | 1
          +----------v---------------------------------+ M
          |                 sales (Fact Table)         |
          +--------------------------------------------+
          | PK, FK | order_id                          |
          | PK, FK | product_id                        |
          |        | sales                             |
          |        | quantity                          |
          |        | discount                          |
          |        | profit                            |
          +--------------------------------------------+
```
</details>

### Table Mapping Definitions

| Table | Entity Type | Purpose & Relational Role |
| :--- | :--- | :--- |
| **`customers`** | Dimension | Holds unique customer identifiers, customer names, and business segments. |
| **`products`** | Dimension | Contains product names, categories, and sub-categories mapped to unique product IDs. |
| **`regions`** | Dimension | Mappable geographic registry cataloging postal codes to cities, states, and regions. |
| **`orders`** | Dimension | Captures order metadata (order date, ship date, ship mode) tied to a customer and region. |
| **`sales`** | Fact | Stores individual transaction line items (sales values, quantities, discounts, and profit margins). |

---

## 📐 Normalization Journey (1NF → 3NF)
A key objective of this project was converting the denormalized database into Third Normal Form (3NF). 

### 1. The Denormalized Starting Point
In the raw spreadsheet, all customer details, shipping information, geographic addresses, and product specifics were repeated for every transaction line.
*   *Anomalies Present:* 
    *   **Insertion Anomaly:** Cannot add a new customer to the database unless they make an active purchase order.
    *   **Update Anomaly:** If a product name changes, it must be updated in thousands of historical sales records.
    *   **Deletion Anomaly:** Deleting an order could completely remove the only record of a specific customer or region.

### 2. Normalization Steps Explained

*   **First Normal Form (1NF):** 
    *   *Requirements:* Atomic column values, unique rows, and defined primary keys.
    *   *Application:* The raw dataset already contained atomic values (no nested arrays or multi-value strings in cells). `row_id` was established as the primary key of the initial flat table.
*   **Second Normal Form (2NF):**
    *   *Concept: No Partial Dependency.* Non-prime attributes must depend on the entire primary key, not a subset of a composite key.
    *   *Application:* Transactions are identified by a composite key of `(order_id, product_id)`. Non-key attributes like `customer_name` depend strictly on `customer_id`, and `product_name` depends strictly on `product_id`. These were moved into separate tables (`customers`, `products`, `orders`) so that non-key attributes depend purely on their respective primary keys.
*   **Third Normal Form (3NF):**
    *   *Concept: No Transitive Dependency.* Non-key attributes must not depend on other non-key attributes ($A \rightarrow B \rightarrow C$).
    *   *Application:* In the `orders` table, details like `state` and `city` depend on `postal_code`, which in turn depends on `order_id` via a geographic mapping. To achieve 3NF, location metrics were extracted into a distinct `regions` lookup table, where `region_id` serves as the primary key.

---

## ⚙️ ETL Pipeline Architecture
The ETL (Extract, Transform, Load) pipeline ensures data integrity and consistency throughout the transaction.

```text
  +------------------+       +------------------+       +------------------+
  |     EXTRACT      |       |    TRANSFORM     |       |       LOAD       |
  |                  |       |                  |       |                  |
  |  Raw Superstore  | ----> |  Python/Pandas   | ----> |   MySQL Engine   |
  |    Excel/CSV     |       |  Format Dates    |       |   Import Staging |
  +------------------+       |  Trim Text       |       +--------+---------+
                             |  Remove Dups     |                |
                             +------------------+                v
                                                        +------------------+
                                                        |  SQL ETL Scripts |
                                                        |  Normalize Data  |
                                                        |  1NF -> 2NF ->3NF|
                                                        +--------+---------+
                                                                 |
  +------------------+       +------------------+                v
  |  VISUALIZATION   |       |    ANALYTICS     |       +--------+---------+
  |                  | <---- |                  | <---- |  Target Tables   |
  |   Power BI BI    |       |   30 Analytical  |       |  (Fact & Dims)   |
  |   Dashboards     |       |    SQL Queries   |       +------------------+
  +------------------+       +------------------+
```

1.  **Extract:** Ingest the raw flat file data.
2.  **Transform (Python & SQL):** 
    *   Standardize text casing and strip whitespace.
    *   Format date patterns (e.g. converting disparate string dates into standard ISO `YYYY-MM-DD` strings).
    *   Filter out fully duplicate transaction rows.
3.  **Load:** Bulk load cleaned raw data into a staging table using `LOAD DATA LOCAL INFILE` in MySQL, then distribute the data structurally into the normalized schema via target SQL `INSERT INTO ... SELECT` statements.

---

## 💻 SQL Business Analytics
Around **30 complex database queries** were developed in [05_bussiness_analytics.sql](file:///c:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/SQL/05_bussiness_analytics.sql) to answer operational questions. They are organized into the following analytical categories:

*   **Data Validation:** Database row validation and integrity checks.
*   **Financial Metrics:** Aggregations of total revenue, profit margins, average order values, and units sold.
*   **Performance Trends:** Monthly, quarterly, and yearly performance trajectories.
*   **Customer Insights:** High-value customers, order frequencies, and behavioral segment analysis.
*   **Product Performance:** Top-ranking products, category performance contributions, and loss-making items.
*   **Geographic Analysis:** Regional distribution patterns, top state markets, and city sales breakdowns.

<details>
<summary>📂 View Sample Advanced Queries (Click to Expand)</summary>

### 1. Populating the Normalized Orders Table
Extracts distinct orders, parses varchar dates to SQL `DATE` types, and maps geographical fields using a join on `regions`:

```sql
INSERT INTO orders (
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    region_id
)
SELECT DISTINCT
    s.order_id,
    STR_TO_DATE(s.order_date, '%Y-%m-%d'),
    STR_TO_DATE(s.ship_date, '%Y-%m-%d'),
    s.ship_mode,
    s.customer_id,
    r.region_id
FROM superstore_raw s
JOIN regions r
    ON s.country = r.country
    AND s.region = r.region
    AND s.state = r.state
    AND s.city = r.city
    AND s.postal_code = r.postal_code;
```

### 2. Top-Performing Product per Category (Window Functions)
Utilizes `DENSE_RANK()` over partitions to identify the highest-earning product catalog item in each sales category:

```sql
WITH product_sales AS (
    SELECT
        p.category,
        p.product_id,
        p.product_name,
        ROUND(SUM(s.sales), 2) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(s.sales) DESC
        ) AS sales_rank
    FROM products p
    JOIN sales s
        ON p.product_id = s.product_id
    GROUP BY
        p.category,
        p.product_id,
        p.product_name
)
SELECT
    category,
    product_name,
    total_sales
FROM product_sales
WHERE sales_rank = 1
ORDER BY category;
```

### 3. Month-over-Month (MoM) Sales Differences (Lag Functions)
Calculates growth rates by referencing preceding monthly metrics using the `LAG()` function:

```sql
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        ROUND(SUM(s.sales), 2) AS total_sales
    FROM orders o
    JOIN sales s
        ON o.order_id = s.order_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)
SELECT
    order_year,
    order_month,
    total_sales,
    LAG(total_sales) OVER (
        ORDER BY order_year, order_month
    ) AS previous_month_sales,
    ROUND(
        total_sales - LAG(total_sales) OVER (
            ORDER BY order_year, order_month
        ),
        2
    ) AS sales_difference
FROM monthly_sales
ORDER BY
    order_year,
    order_month;
```
</details>

---

## 📊 Power BI Data Modeling & Dashboards
The Power BI file `SQL_PROJ_backup.pbix` establishes a clean dimensional model mirroring the database schema.

### Data Modeling Relationships
*   `customers` (1) ─── (🍁) `orders` (1) ─── (🍁) `sales` (Fact)
*   `regions` (1) ─── (🍁) `orders`
*   `products` (1) ─── (🍁) `sales` (Fact)

### Key DAX Measures
*   **`Total Sales`** = `SUM(sales[sales])`
*   **`Total Profit`** = `SUM(sales[profit])`
*   **`Total Units Sold`** = `SUM(sales[quantity])`
*   **`Total Orders`** = `DISTINCTCOUNT(sales[order_id])`
*   **`Profit Margin %`** = `DIVIDE([Total Profit], [Total Sales], 0) * 100`
*   **`Average Order Value (AOV)`** = `DIVIDE([Total Sales], [Total Orders], 0)`

### Visual Layout & Interactive Elements
*   **Core KPIs:** Cards showing Total Sales, Total Profit, Margin %, AOV, and Active Customers.
*   **Temporal Performance:** Sales & Profit year-over-year line charts.
*   **Geographic Sales Heatmap:** Visualizing sales contribution across USA regions and states.
*   **Market Share Charts:** Product category breakdown (doughnut chart) and customer segments (bar chart).
*   **Top lists:** Dynamic rankings showing the top 5 revenue-generating items.

---

## 🖼️ Dashboard Preview

![Power BI Sales Performance Analytics Dashboard](Images/Dashboard/DASHBOARD.png)

<details>
<summary>📊 View Dashboard Layout Mockup Representation</summary>

```text
+-----------------------------------------------------------------------------------+
|  [SLICERS: Year | Region | State]                                                |
+-----------------------------------------------------------------------------------+
|  +--------------------+  +--------------------+  +--------------------+  +-----+  |
|  |  TOTAL SALES       |  |  TOTAL PROFIT      |  |  PROFIT MARGIN     |  | AOV |  |
|  |  $2.30 M           |  |  $286.40 K         |  |  12.45%            |  | $458|  |
|  +--------------------+  +--------------------+  +--------------------+  +-----+  |
+-----------------------------------------------------------------------------------+
|  [ Sales Trend (2014-2017) ]             | [ Regional Contribution ]              |
|   $k |                                    |                                       |
|  800 |          .-'                       |   West   : ################### [37%]  |
|  600 |       .-'                          |   East   : ############### [29%]      |
|  400 |  _..-'                             |   Central: ########### [21%]          |
|  200 |'                                   |   South  : ####### [13%]              |
|    0 +----------------                    |                                       |
|      2014  2015  2016  2017               |                                       |
+-----------------------------------------------------------------------------------+
|  [ Sales by Product Category ]            | [ Top 5 Products by Sales ]           |
|                                           |                                       |
|  * Technology   (36.4%)                   |  1. Canon ImageCLASS   (+$61.6k)      |
|  * Furniture    (32.3%)                   |  2. Fellowes Shredder  (+$27.5k)      |
|  * Office Supp. (31.3%)                   |  3. Beckett Bookcase   (+$21.8k)      |
+-----------------------------------------------------------------------------------+
```
</details>

> [!NOTE]
> *Actual dashboard visuals are stored in the [Images/Dashboard/](file:///c:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/Images/Dashboard) folder.*

---

## 💡 Business Insights
*   **Growth Trajectory:** Sales metrics exhibit consistent year-over-year growth, showing a sharp expansion curve in overall volume post-2015.
*   **Regional Strength:** The **West Region** represents the highest revenue-generating territory, followed closely by the East, while the South offers expansion opportunities.
*   **Category Performance:** **Technology** yields the highest revenue and profit margins, whereas **Furniture**, despite matching sales volumes, delivers low profit margins due to steep shipping costs and high product discounts.
*   **Segment Concentration:** The **Consumer Segment** represents over 50% of the customer transaction volume, marking it as the primary target for marketing campaigns.
*   **Shipping Optimization:** **Standard Class Shipping** handles more than 60% of all customer orders, making it the logistically optimal channel for shipping rate negotiations.

---

## 🛠️ Project Challenges & Technical Resolutions

During the implementation of this Business Intelligence project, several data-engineering and schema-design challenges were resolved:

### 1. Clean Staging Import & String Stripping
*   *Problem:* The raw CSV dataset contained trailing whitespaces in `customer_id` and `product_id` strings. This caused joins to fail silently when extracting and loading primary keys.
*   *Solution:* Preprocessed the fields in Python using `.str.strip()` prior to CSV generation, ensuring accurate ID matching.

### 2. VARCHAR to DATE Conversion
*   *Problem:* In the raw source, dates were stored as strings. MySQL requires `DATE` fields formatted as `YYYY-MM-DD` for temporal queries and indexing.
*   *Solution:* Imported dates into a staging table as `VARCHAR`, then loaded them into the target `orders` table using `STR_TO_DATE(order_date, '%Y-%m-%d')`.

### 3. Primary Key Violations on Product Extraction
*   *Problem:* Extracting distinct product dimensions via `SELECT DISTINCT product_id, product_name` resulted in duplicate keys. This occurred because a single product ID was recorded with spelling variations over time.
*   *Solution:* Grouped records by `product_id` and selected the minimum alphabetical spelling (`MIN(product_name)`) to enforce key uniqueness.

### 4. Resolving Many-to-Many Relationships in Power BI
*   *Problem:* Connecting the `products` table directly to transactions using multiple pathways caused circular dependency paths and many-to-many ambiguity.
*   *Solution:* Redesigned the model to conform strictly to a Star Schema. Relationships flow downward from Dimension tables to the central Fact table, resolving the ambiguity.

---

## 📂 Project Structure
```text
Sales-Performance-Analytics/
├── Dataset/
│   └── Superstore_Clean.csv            # Standardized CSV source
├── Images/
│   ├── Dashboard/                      # Dashboard screenshot directory
│   └── Model/                          # Data model diagram directory
├── PowerBI/
│   └── SQL_PROJ_backup.pbix            # Power BI dashboard layout file
├── SQL/
│   ├── 00_create _database.sql         # Database initializer
│   ├── 01_schema_creation.sql          # Relational tables setup
│   ├── 02_data_loading.sql             # Staging CSV loader
│   ├── 03_ETL_normalization.sql         # Normalization SQL script
│   ├── 04_data_validation.sql          # Row count validation checks
│   └── 05_bussiness_analytics.sql      # Analytical queries suite
└── README.md                           # Project documentation
```

---

## ⚙️ Installation & Execution Guide

Follow these steps to set up and run the project environment locally:

### Prerequisites
*   MySQL Server 8.0+
*   Power BI Desktop (for dashboard modeling)
*   Python 3.9+ (Optional: only if running the raw cleaning scripts)

### Step 1: Clone the Repository
```bash
git clone https://github.com/chidvi123/sales-performance-analytics.git
cd sales-performance-analytics
```

### Step 2: Initialize Database and Schema
Log into your local MySQL CLI or GUI client (like MySQL Workbench) and execute the SQL scripts sequentially:
1.  **Initialize Database:** Run [00_create _database.sql](file:///c:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/SQL/00_create%20_database.sql) to set up the catalog.
2.  **Generate Target Schema:** Run [01_schema_creation.sql](file:///c:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/SQL/01_schema_creation.sql) to build raw staging and target normalized tables.

### Step 3: Load Data & Execute ETL Normalization
1.  **Load CSV:** Run [02_data_loading.sql](file:///c:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/SQL/02_data_loading.sql) to ingest data into `superstore_raw`. Make sure the file path matches your local setup directory.
2.  **ETL Migration:** Run [03_ETL_normalization.sql](file:///c:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/SQL/03_ETL_normalization.sql) to distribute staging columns into normalized tables.
3.  **Run Validation:** Run [04_data_validation.sql](file:///c:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/SQL/04_data_validation.sql) to verify that row volumes match expected thresholds.

### Step 4: Run Analytics & Open Dashboards
*   Execute queries from [05_bussiness_analytics.sql](file:///c:/Users/ADMIN/Documents/Projects/Sales-Performance-Analytics/SQL/05_bussiness_analytics.sql) to extract business insights directly from the command line.
*   Open the visual dashboard file in **Power BI Desktop** (`PowerBI/SQL_PROJ_backup.pbix`) to explore the interactive visual metrics.

---

## 📈 Key Learning Outcomes
*   **Database Normalization Strategy:** Transitioned flat file schemas into 3NF structures to improve transactional performance.
*   **ETL Architecture Design:** Programmed staging tables and targeted queries to move and transform data safely.
*   **Advanced Analytics Engineering:** Wrote SQL window functions (`DENSE_RANK()`) and lag functions (`LAG()`) to compute rankings and MoM growth metrics.
*   **Star Schema Optimization:** Created a clean Star Schema in Power BI to ensure consistent filtering behavior across visuals.

---

## 🔮 Future Scalability Enhancements
*   **Automated Pipelines:** Implement Apache Airflow to orchestrate database loads and update schedules automatically.
*   **Cloud Warehousing Migration:** Migrate the relational warehouse to Snowflake or Google BigQuery to manage larger datasets.
*   **Data Build Tool (dbt):** Integrate dbt for modular SQL transformations, data lineage tracing, and automated validation tests.

---

## 👤 Author
*   **Chidvilas** - *Initial Work & Architecture* - [chidvi123](https://github.com/chidvi123)

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
