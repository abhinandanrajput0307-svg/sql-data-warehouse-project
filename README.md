Modern Data Warehouse & Analytics EngineA production-ready Data Warehouse built on MySQL, implementing a clear Medallion Architecture (Bronze, Silver, and Gold layers) to transform raw transactional data into clean, business-ready analytical datasets.

🚀 Architecture OverviewPlaintext
┌───────────────┐     ┌──────────────┐     ┌──────────────┐     ┌─────────────┐     ┌─────────────────┐
│ Data Sources  │ ──▶ │ Bronze Layer │ ──▶ │ Silver Layer │ ──▶ │ Gold Layer  │ ──▶ │   Consumption │
│ (CRM/ERP CSV) │     │  (Raw Data)  │     │  (Cleaned)   │     │ (Biz Ready) │     │  (BI/SQL/ML)    │
└───────────────┘     └──────────────┘     └──────────────┘     └─────────────┘     └─────────────────┘


🛠️ Medallion Pipeline Specifications🥉 Bronze Layer (Raw Data)Source: CRM & ERP CSV files loaded via batch folder drops.Transformation: None. Data is loaded as-is into staging tables using Full Load (Truncate & Insert).🥈 Silver Layer (Cleaned & Standardized)Transformation: Focuses on data cleaning, standardization, normalization, and adding derived or enriched columns.Structure: Physical tables updated via batch processing.🥇 Gold Layer (Business Ready)Transformation: Applies business logic and aggregations.Data Model: Modeled into Star Schemas, flat tables, and aggregated structures.Storage: Implemented as virtual Views (no physical storage/load required).📊 Data Consumption LayerThe business-ready datasets in the Gold Layer power three core downstream tracks:BI and Reporting: Clean data feeds for interactive dashboards (e.g., Power BI, Tableau).Ad-Hoc SQL Queries: Simplified, pre-joined tables for fast analyst queries.Machine Learning: Cured flat views ready for data science feature engineering.

About Me
Hi, I'm Abhinandan Kumar! 👋  I am a passionate data professional currently pivoting into Data Analytics and Business Intelligence. With a strong foundational background in managing customer-centric workflows and operations, I focus on transforming messy operational data into clean, structured, and highly actionable enterprise insights.  Technical Focus: SQL, Data Warehouse Architecture, ETL/ELT Pipelines, Excel, and Power BI.  Core Philosophy: Building clean, optimized, and well-documented data environments that enable quick, data-driven decisions.

📄 LicenseThis project is licensed under the MIT License - see the LICENSE file for details.
