## Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

🎯 This repository is an excellent resource for professionals and students looking to showcase expertise in:
- SQL Development
- Data Architect
- Data Engineering  
- ETL Pipeline Developer  
- Data Modeling  
- Data Analytics  

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.  



## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                                           # Project documentation and architecture details
│   ├── WareHouse_Architecture.drawio               # Draw.io file shows the project's architecture
│   ├── data_catalog.md                             # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.png                               # .png file for the data flow diagram
│   ├── Data_Model_reprenting_gold_layer.jpeg       # .jpeg file for objects in gold layer (star schema)
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```
---


## 🌟 About Me

<p align="left">
<b>Sachin Khajuria here!👋 </b>
<b>Hello, I am Sachin Khajuria, an IT professional, Data Engineer and a aspiring Data Architect on a mission to make working with data fun and accessible.</b>
<br>
</p>

---

## ☕ Stay Connected

Let's stay in touch! Feel free to connect with me on the following platforms:
###
<div align="left">

[![LinkedIn (Bold)](https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/sachin-khajuria)
[![Portfolio (Bold)](https://img.shields.io/badge/Portfolio-View-green?style=for-the-badge&logo=internet-explorer&logoColor=white)](https://sachinkhajuria.super.site/)
</div>

---



## ✨ Credits & Acknowledgments
<div align="left">


### Special Thanks

- This project was built following an excellent tutorial by **[DataWithBaraa](https://github.com/DataWithBaraa)**

- A huge thank you for creating such comprehensive and well-structured learning content!

#### 📺 Tutorial Resources
[![YouTube Tutorial](https://img.shields.io/badge/YouTube-Watch%20Tutorial-red?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/watch?v=9GVqKuTVANE&list=PLNcg_FV9n7qaUWeyUkPfiVtMbKlrfMqA8&t=14701s)
[![GitHub Repository](https://img.shields.io/badge/GitHub-Original%20Repo-black?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DataWithBaraa/sql-data-warehouse-project/tree/main)

</div>



---
## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

---
