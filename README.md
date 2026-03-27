#  Customer Ticket Resolution Time Analysis  
**Power BI | SQL | Data Cleaning | DAX | Dashboarding**

A complete end-to-end analytics project focused on understanding ticket resolution behavior, SLA performance, and operational bottlenecks in customer support systems.

---

## Project Overview

The goal of this project was to analyze:

- How efficiently customer support tickets are being resolved  
- Where major delays occur  
- How SLA performance impacts customer satisfaction  
- How workload distribution affects resolution time  

> **This project includes end-to-end data cleaning, modeling, DAX calculations, dashboard creation, and SQL-based validation.**

---

## Tools & Technologies Used

- **Power BI Desktop**  
- **Power Query**  
- **DAX**  
- **SQL (for validation)**  
- **Excel (initial preprocessing)**  

---

## Data Cleaning (Power Query)

Performed extensive cleaning steps:

- Removed duplicates  
- Standardized date/time formats  
- Cleaned null/blank fields  
- Trimmed and cleaned text values  
- Converted incorrect data types  
- Standardized priority categories  
- Created new calculated columns for analysis  

---

## Data Modeling

The data model includes:

- Fact table containing ticket records  
- Dimension tables for priority, customer, agents, and departments  
- One-to-many relationships  
- DAX Measures created for KPI calculations  

---

## Key DAX Measures

- **Total Tickets**  
- **Closed Tickets**  
- **Closed %**  
- **Open Tickets**  
- **SLA Met Tickets**  
- **SLA %**  
- **Avg Resolution Hours**  
- **Resolution Days**  

---

## Key Insights

###  Strong closure rate  
- **93.28%** of total tickets were successfully closed  

###  Weak SLA performance  
- Only **1,443 tickets** met the SLA  
- SLA Compliance: **~11%**  
- Nearly **89% of tickets breached SLA**

###  High resolution time  
- Average resolution time: **154 hours (~6.4 days)**  

###  Low backlog  
- Open tickets: **847**  
- Backlog = **6.5%** of total volume  

###  Operational findings  
- High-priority tickets faced longest delays  
- Certain departments showed higher SLA breaches  
- Agent workload imbalance increased resolution time  
- SLA breach strongly impacted customer satisfaction  

---

##  Dashboard Screenshots

(Add your images after uploading them into a **screenshots/** folder)

Example:

![Dashboard Overview](screenshots/dashboard1.png)  
![SLA Analysis](screenshots/dashboard2.png)  
![Agent Performance](screenshots/dashboard3.png)

---

##  SQL Validation

SQL queries were used to verify:

- Ticket counts  
- Closed ticket counts  
- SLA met numbers  
- Resolution hours  
- Priority-based performance  

✔ Only SQL **screenshots** are included in this repository.  
Folder: `SQL_Screenshots/`

---

##  Project Deliverables

This repository contains:

- ✔ Power BI Dashboard Recording (Video)  
- ✔ Power BI PBIX File  
- ✔ Project PPT  
- ✔ SQL Query Screenshots  
- ✔ Dashboard images  
- ✔ README documentation  

---

##  How to View the Dashboard

1. Download the `.pbix` file  
2. Open in **Power BI Desktop**  
3. Explore report pages & KPIs  
4. All DAX, modeling, and cleaning steps are pre-applied  

---

##  Conclusion

This project highlights how customer support operations can be improved by analyzing ticket resolution bottlenecks, SLA performance, and workload distribution.  
The insights gained help organizations enhance operational efficiency and improve customer satisfaction.

---

##  Contact

**LinkedIn:** *www.linkedin.com/in/taniya-payal-090a0a281*  
**GitHub:** *https://lnkd.in/gZ2w7yvd*  

