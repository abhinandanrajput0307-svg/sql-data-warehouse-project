# 🚀 SQL Data Warehouse & Analytics Project

An end-to-end data warehouse project built with **MySQL**, transforming raw CRM and ERP data into clean, structured, and business-ready datasets for analysis.

The project follows a **Medallion Architecture (Bronze, Silver, and Gold)** and includes data ingestion, data cleaning, dimensional modeling, exploratory data analysis, and advanced SQL analytics.

## 📌 Project Overview

The goal of this project is to demonstrate how raw operational data can be transformed into a reliable analytical data warehouse and used to generate meaningful business insights.

The project covers the complete workflow:

**Raw Data → ETL → Data Warehouse → Data Modeling → Analytics**

## 🏗️ Architecture

```text
CRM & ERP CSV Files
        │
        ▼
┌─────────────────────┐
│   Bronze Layer      │
│   Raw Data          │
│   Full Load         │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Silver Layer      │
│   Cleaned &         │
│   Standardized Data │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│    Gold Layer       │
│  Business-Ready     │
│  Analytical Views   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│     Analytics       │
│  EDA & Advanced SQL │
│      Analysis       │
└─────────────────────┘
```

## 🛠️ Technologies Used

* **MySQL** — Data warehouse development and SQL analysis
* **SQL** — Data transformation, data cleaning, joins, aggregations, CTEs, and window functions
* **CSV** — Source data format
* **Git & GitHub** — Version control and project documentation

## 🥉 Bronze Layer — Raw Data

The Bronze Layer stores data ingested from CRM and ERP CSV files.

### Key Activities

* Loading raw source data into staging tables
* Preserving the original source structure
* Performing full-load ingestion
* Maintaining a raw representation of the operational data

**Purpose:** Provide a starting point for downstream data cleaning and transformation.

## 🥈 Silver Layer — Cleaned & Standardized Data

The Silver Layer transforms raw data into cleaner and more consistent datasets.

### Key Activities

* Data cleaning and standardization
* Handling missing and inconsistent values
* Removing duplicates
* Data type conversions
* Data validation
* Preparing data for analytical modeling

**Purpose:** Create reliable and usable datasets for the Gold Layer.

## 🥇 Gold Layer — Business-Ready Data

The Gold Layer contains business-ready datasets designed for analytical queries and reporting.

### Key Activities

* Creating analytical views
* Combining CRM and ERP data
* Applying business logic
* Building customer and product reporting datasets
* Preparing data for exploratory and advanced analytics

**Purpose:** Make the data easier to query and use for business analysis.

## 📊 Analytics

The `analytics` folder contains SQL queries that demonstrate how the data warehouse can be used to answer business questions.

### Exploratory Data Analysis

The EDA queries focus on understanding the data and identifying important patterns.

Examples include:

* Exploring customer and product data
* Understanding sales trends
* Examining data distributions
* Identifying important business dimensions
* Checking data quality and consistency

📁 [`analytics/01_eda.sql`](analytics/01_eda.sql)

### Advanced Analytics

The advanced analytics queries focus on extracting deeper business insights using SQL.

Examples include:

* Ranking customers and products
* Calculating running totals
* Comparing current and previous periods
* Analyzing customer behavior
* Measuring sales performance
* Using window functions and CTEs for complex analysis

📁 [`analytics/02_advanced_analytics.sql`](analytics/02_advanced_analytics.sql)

### Customer Report

A dedicated analytical report focused on customer-level insights.

📁 [`analytics/03_customer_report.sql`](analytics/03_customer_report.sql)

### Product Report

A dedicated analytical report focused on product-level insights.

📁 [`analytics/04_product_report.sql`](analytics/04_product_report.sql)

## 📁 Project Structure

```text
sql-data-warehouse-project/
│
├── datasets/
│   └── CRM & ERP source CSV files
│
├── docs/
│   └── Data warehouse documentation
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── analytics/
│   ├── 01_eda.sql
│   ├── 02_advanced_analytics.sql
│   ├── 03_customer_report.sql
│   └── 04_product_report.sql
│
├── tests/
│   └── Data quality checks
│
├── README.md
└── LICENSE
```

## 🎯 Key Learning Outcomes

Through this project, I practiced:

* Building an end-to-end SQL data warehouse
* Designing a Bronze–Silver–Gold architecture
* Writing ETL scripts in MySQL
* Cleaning and transforming raw data
* Creating analytical views
* Writing complex SQL queries
* Using CTEs and window functions
* Performing exploratory data analysis
* Generating customer and product insights
* Organizing SQL projects using GitHub

## 🚀 How to Use

1. Clone the repository.
2. Open the SQL scripts in MySQL.
3. Load the source data from the `datasets` folder.
4. Execute the Bronze, Silver, and Gold layer scripts.
5. Run the analytics queries from the `analytics` folder.

## 👨‍💻 About Me

Hi, I'm **Abhinandan Kumar**, an aspiring Data Analyst with a background in customer support and operations.

I am currently building my skills in **SQL, Excel, data analytics, and business intelligence**, with a focus on transforming data into meaningful business insights.

This project represents my practical learning in **data warehousing, ETL, SQL analytics, and data modeling**.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
