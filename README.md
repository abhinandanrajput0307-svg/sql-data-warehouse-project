# 🚀 Modern Data Warehouse & Analytics Engine

A production-ready Data Warehouse built on **MySQL**, implementing a multi-tiered **Medallion Architecture** (Bronze, Silver, and Gold layers) to transform raw transactional data into clean, business-ready analytical datasets.

---

## 🏗️ Architecture Overview

This project follows an end-to-end Medallion pipeline architecture designed to incrementally ingest, sanitize, normalize, and model enterprise data within MySQL.

<div align="center">
  <img width="672" height="684" alt="Data Warehouse Medallion Architecture" src="https://github.com/user-attachments/assets/e36df8d1-06ed-4a64-9962-9e01c89da202" />
</div>

---

## 🛠️ Medallion Pipeline Specifications

### 🥉 Bronze Layer (Raw Ingestion)
* **Data Sources:** CRM & ERP CSV files ingested via batch folder drops.
* **Transformation:** None (Ingested *as-is*).
* **Load Strategy:** Full Load (`TRUNCATE` & `INSERT`) into staging tables.
* **Purpose:** Acts as an immutable historical record of raw operational source data.

### 🥈 Silver Layer (Cleaned & Standardized)
* **Transformation:** Focuses on data cleaning, deduplication, type casting, standardization, and schema normalization.
* **Enrichment:** Adds derived attributes, surrogate keys, and system metadata.
* **Storage Structure:** Physical relational tables optimized for data quality and integration, updated via scheduled batch jobs.

### 🥇 Gold Layer (Business Ready)
* **Transformation:** Applies business logic, analytical logic, and pre-computed aggregations.
* **Data Modeling:** Modeled into optimized **Star Schemas** (Fact & Dimension tables) and flattened reporting layer structures.
* **Storage Structure:** Implemented as lightweight **Virtual Views** to eliminate unnecessary physical storage overhead.

---

## 📊 Data Consumption Layer

The business-ready datasets in the Gold Layer directly empower three primary downstream analytics tracks:

* **📈 BI & Reporting:** Clean feeds designed for interactive dashboards (Power BI, Tableau).
* **🔍 Ad-Hoc Analytics:** Pre-joined, simplified structures for rapid querying by business analysts.
* **🤖 Machine Learning:** Cured, feature-ready flat views ready for data science workflows.

---

## 👨‍💻 About Me

Hi, I'm **Abhinandan Kumar**! 

I am a data professional specializing in **Data Analytics** and **Business Intelligence**. Leveraging a solid background in customer-centric operations, I bridge the gap between business processes and technical data solutions—transforming complex, unstructured operational data into clean, scalable, and actionable enterprise insights.

* **Core Competencies:** SQL, Data Warehouse Architecture, ETL/ELT Pipelines, Data Modeling, Excel, Power BI.
* **Design Philosophy:** Building clean, optimized, and well-documented data environments that empower confident, data-driven decisions.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
