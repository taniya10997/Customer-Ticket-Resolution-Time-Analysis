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
**Executive Overview: Ticketing Dashboard**
This dashboard tracks the overall performance of the ticket management system.
-Key Stats: Managed 13K total tickets with an impressive 93.28% closure rate.
-Insights: Displays ticket distribution by Priority, SLA Status, and Department.
-Trends: Monitors monthly and yearly ticket volumes to analyze support efficiency and workload.

<img width="1369" height="772" alt="Screenshot (928)" src="https://github.com/user-attachments/assets/0bcc51a6-154b-485c-bef7-9543cd95398d" />

---
**Resolution & SLA Analysis Dashboard**
This dashboard focuses on support efficiency and SLA (Service Level Agreement) performance.
-Key Metrics: Tracks an average resolution time of 6.42 days and 154 hours, with a total of 1,443 SLA Met tickets.
-SLA Compliance: Highlights a critical 89% SLA Breach rate, showing the need for faster ticket resolution.
-Performance Trends: Analyzes Avg Resolution Time by Month and SLA Compliance Trends to identify service gaps.
-Ticket Breakdown: Categorizes tickets into Resolution Time Buckets (Slow, Medium, Fast) and provides granular details by agent and priority.

<img width="1413" height="784" alt="Screenshot (929)" src="https://github.com/user-attachments/assets/8ed654ba-7e97-4d72-9b02-c4e91963ced6" />

---
**Agent Performance & Productivity Dashboard**
This dashboard tracks agent efficiency and ticket handling trends.
-Productivity Metrics: Monitors Tickets Handled vs. Resolution Time and identifies the Top 10 Agents by ticket volume.
-Workload Distribution: Includes an Agent Activity Heatmap to track ticket priority distribution across the team.
-Quality & Speed: Features Average Resolution Days by Agent and SLA Met % by Agent to measure service quality.
-Key Stats: Provides a quick view of Total (13K), Open (847), and Closed (12K) tickets, along with a 93.28% closure rate.

<img width="1394" height="796" alt="Screenshot (930)" src="https://github.com/user-attachments/assets/2a9331a5-6b0c-4675-a5b6-1588f6b2fc2e" />

---
**Customer & CSAT Insights Dashboard**
-This dashboard focuses on customer satisfaction (CSAT) and feedback analysis.
-CSAT Scores: Tracks Avg CSAT (2.99) and compares it across MTD (Month-to-Date) and YTD (Year-to-Date) to monitor service quality.
-Customer Feedback: Highlights that 100% of tickets have feedback, with a breakdown of High Satisfaction (40.42%) vs. Low Satisfaction (40.44%).
-Geographic & Trend Analysis: Shows Open Tickets MoM (Month-on-Month) growth by state and overall trends to identify regional service issues.
-Customer Segmentation: Categorizes ticket counts by Customer Type (Loyal, Regular, Unknown) and provides a list of Top Customers based on their satisfaction levels.
<img width="1420" height="799" alt="Screenshot (931)" src="https://github.com/user-attachments/assets/7bd94431-4c45-40b1-a03d-db61414cc8b6" />



---
**Workload & Capacity Management Dashboard**
This dashboard monitors team productivity and workload distribution.
-Capacity Metrics: Tracks Total Agents (320) and identifies 92 Overloaded Agents vs. 228 Underutilized Agents.
-Workload Balance: Shows an Average of 39.26 tickets per agent, helping to manage a workload imbalance score of 0.29.
-Efficiency Trends: Analyzes Workload Trends Over Time and correlates Workload vs. Resolution Efficiency.
-Performance Ranking: Includes an Agent Consistency Ranking and segmentation to ensure balanced ticket distribution across departments.

<img width="1380" height="776" alt="Screenshot (932)" src="https://github.com/user-attachments/assets/63c1ad3c-7d60-4bcb-851a-526d37f43d41" />



## SQL Queries & Data Modeling Sample
```-- 1) Avg Resolution Days + Avg Resolution Hours (Basic)
SELECT
    ROUND(AVG(resolution_days), 2) AS avg_resolution_days,
    ROUND(AVG(resolution_time_hour), 2) AS avg_resolution_hours
FROM vw_fact_ticket
WHERE resolution_days IS NOT NULL
AND resolution_time_hour IS NOT NULL;

-- 2) SLA Met %, SLA Breached %, & SLA Met Tickets (KPI cards)
SELECT
    ROUND(SUM(CASE WHEN sla_status = 'SLA Met' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_met_pct,
    ROUND(SUM(CASE WHEN sla_status = 'SLA Breached' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_breached_pct,
    SUM(CASE WHEN sla_status = 'SLA Met' THEN 1 ELSE 0 END) AS sla_met_tickets
FROM vw_fact_ticket
WHERE sla_status IS NOT NULL;
```
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

