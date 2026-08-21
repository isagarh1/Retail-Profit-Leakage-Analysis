# Retail Profit Leakage & Operational Analytics

An end-to-end **Retail Analytics project** using **PostgreSQL and Power BI** to identify profit leakage, investigate its underlying drivers, and translate the findings into actionable business recommendations.

---

## Business Problem

Retail businesses can generate strong sales while still experiencing weak profitability due to **discounting, low-margin products, returns, and operational inefficiencies**.

This project investigates where profitability is being lost and identifies the key product and pricing factors associated with weak margins.

### Key Business Questions

* Which categories and sub-categories generate the lowest profitability?
* Which products contribute most to profit leakage?
* How does discounting relate to profitability?
* Which regions have weak profit performance despite strong sales?
* Are returns a significant contributor to profit leakage?
* Which areas should management prioritize for corrective action?

---

## Business Objectives

* Analyze sales, profit, and profit margin across products and regions.
* Identify low-margin and loss-making products.
* Evaluate the relationship between discounts and profitability.
* Analyze return and fulfillment performance.
* Perform Root Cause Analysis (RCA) on major profit leakage areas.
* Translate findings into actionable pricing and profitability recommendations.

---

## Key Business Metrics

| Metric                    |         Value |
| ------------------------- | ------------: |
| **Total Sales**           |    **$2.30M** |
| **Total Profit**          |   **$286.4K** |
| **Profit Margin**         |    **12.47%** |
| **Total Orders**          |     **5,009** |
| **Return Rate**           |      **5.91%** |
| **Avg. Fulfillment Days** | **34.6 Days** |

---

## Dataset

| Attribute       | Details                               |
| --------------- | ------------------------------------- |
| **Domain**      | Retail Analytics                      |
| **Records**     | 9,994                                 |
| **Columns**     | 22                                    |
| **Granularity** | Order-Level Transactions              |
| **Tools**       | PostgreSQL, Power BI, Microsoft Excel |

The dataset contains customer, order, product, sales, profit, discount, shipping, return, and regional information.

---

## Analytical Approach

### 1. Data Validation

* Validated order-level transaction data.
* Checked data types and data quality.
* Reviewed sales, profit, discount, return, and fulfillment fields.
* Validated KPI calculations before dashboard development.

### 2. SQL Business Analysis

Used **PostgreSQL** to perform business-focused analysis using:

* `Aggregations` and `GROUP BY`
* `CASE WHEN`
* `Common Table Expressions (CTEs)`
* `Window functions`
* `Ranking`
* `Time-series analysis`
* `Profit margin calculations`
* `Discount analysis`
* `Product and regional profitability analysis`

### 3. Power BI Analysis

Built interactive dashboards to analyze:

* Overall business performance
* Product and category profitability
* Regional performance
* Discount impact
* Returns
* Fulfillment performance
* Profit leakage

### 4. Root Cause Analysis

The investigation followed a drill-down approach:

**Category → Sub-Category → Product → Region → Discount → Profitability**

This was used to identify the areas most strongly associated with negative or weak profitability.

---

# Key Findings

### 1. Furniture had the lowest profitability

Furniture recorded the lowest profit margin at approximately **2.49%**, significantly below the overall business margin.

### 2. Tables were a major source of profit leakage

The **Tables** sub-category generated negative profit across multiple regions and emerged as the primary area requiring further investigation.

### 3. High discounts were associated with weak profitability

Furniture products with discounts above approximately **20%** showed substantially weaker profitability, with several products generating negative profit.

### 4. Higher sales did not always mean higher profit

Regional analysis showed that strong sales performance did not necessarily translate into strong profitability.

### 5. Returns were not the primary identified driver

Return rates remained relatively stable during the investigation and did not explain the major profitability issue identified in the Furniture/Table segment.

---

# Root Cause Analysis

The analysis narrowed the profitability problem from the overall business to a specific product and pricing pattern:

**Overall Profitability**

↓

**Furniture Category**

↓

**Tables Sub-Category**

↓

**Multiple Regions**

↓

**High Discount Levels**

↓

**Negative / Weak Profitability**

### RCA Conclusion

The primary profitability issue identified was concentrated in **low-performing Furniture products, particularly Tables**, where higher discount levels coincided with negative profitability across multiple regions.

Returns were investigated but did not emerge as the primary contributor to the identified profit leakage.

---

# Business Recommendations

### 1. Introduce Margin-Based Discount Controls

Set minimum margin thresholds for discounts, particularly for low-margin products.

### 2. Review Tables Pricing

Conduct a product-level review of Tables to evaluate:

* Pricing
* Discount levels
* Regional performance
* Product profitability

### 3. Monitor Profit Alongside Revenue

Track **Sales, Profit, Margin, Discount, and Returns** together instead of evaluating revenue growth independently.

### 4. Establish Profitability Monitoring

Regularly monitor:

* Negative-profit products
* High-discount transactions
* Low-margin categories
* Regional margin deterioration
* Return-rate changes

---

# Dashboard

The Power BI solution contains three analytical views:

### Executive Overview

Provides a high-level view of sales, profit, margin, orders, returns, fulfillment, category performance, and regional performance.

![Executive Overview]<img width="1451" height="826" alt="Overview" src="https://github.com/user-attachments/assets/6666fcf2-0c07-4656-955b-4b5e1dc85539" />


### Profit Leakage & Operational Analytics

Focuses on product profitability, discounts, regional performance, returns, and operational metrics.

![Profit Leakage]<img width="1458" height="820" alt="Profit leakage" src="https://github.com/user-attachments/assets/0295f3e3-11ad-4b2c-9da5-abcedad73ffb" />

### Profit Leakage Investigation — RCA

Provides a detailed drill-down into the identified profitability issue.

![Profit Leakage Investigation]<img width="1452" height="816" alt="Investigation" src="https://github.com/user-attachments/assets/f03a8fde-922b-4bbf-bef2-79c59dae4fd7" />

---

## Tools & Technologies

* **PostgreSQL** — Data analysis and business-focused SQL
* **Power BI** — Interactive dashboards and KPI reporting
* **Microsoft Excel** — Data preparation and validation

---

## Project Outcome

The project identified **Furniture, particularly Tables, as a major area of profit leakage** and highlighted the relationship between high discount levels and weak profitability.

The analysis demonstrates an end-to-end workflow:

**Business Problem → Data Analysis → SQL → Power BI → Root Cause Analysis → Business Recommendations**

---

## Author

**Sagar Hiware**

Data Analyst | SQL | Power BI | Business Analytics
