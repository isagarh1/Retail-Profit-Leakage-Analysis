# Retail Profit Leakage & Operational Analytics
- Tools: PostgreSQL · SQL · Power BI
- Project type: Independent data analytics portfolio project
- Analytical approach: Descriptive → Diagnostic → Prescriptive
---
## Project Overview
This project analyzes retail sales and product economics to understand how sales performance, discount depth, product cost, and SKU/category differences relate to gross profitability. The objective is to move beyond reporting sales totals and identify areas that warrant further business investigation and action.

PostgreSQL is used for data-quality checks, analytical views, and business analysis. Power BI presents the headline KPIs, profitability patterns, discount analysis, and recommended areas for review.

## Business Problem
Strong sales do not necessarily mean strong profitability. Gross margin can vary across discount levels, product categories, and individual SKUs, so the business needs to identify where profitability is weak and which patterns warrant further investigation.

Central business question: Where should the business investigate potential profit leakage, and what actions are supported by the available evidence?

The analysis focuses on discount depth, gross margin, and product-level profitability to identify areas for review. These patterns are treated as diagnostic signals, not proof that discounting alone caused low or negative margins.

## Business Questions
- How are net sales, units sold, gross profit, and gross margin performing?
- How does profitability vary across product categories, SKUs, stores, and sales channels?
- How does gross margin vary across discount bands?
- Which products or segments show low or negative gross profit?
- Which pricing, product-cost, or inventory areas should be investigated further?
- What actions should the business prioritize based on the observed patterns?

## Tools and Workflow
- PostgreSQL / SQL: data validation, joins, analytical views, aggregations, and business-question queries.
- Power BI: KPI reporting, category and SKU comparison, discount-depth analysis, and an action-oriented dashboard.

## Workflow
- **Understand the business problem** :— define the profitability and discount-related questions.
- **Validate the data** :— check row counts, key uniqueness and nulls, relationships, duplicate-like records, business rules, price/discount consistency, and date coverage.
- **Prepare the analytical layer** :— use SQL views to enrich sales records with product, store, and customer attributes and calculate sales, discount, cost, and gross-profit fields. An inventory-risk view is also included in the SQL work.
- **Perform descriptive analysis** :— summarize sales and profitability and compare results across time and business dimensions.
- **Perform diagnostic analysis** :— compare gross margin across discount bands and identify low-margin or negative-gross-profit SKU/category patterns.
- **Translate findings into actions** :— identify discount practices, low-margin products, and product-economics or inventory areas requiring further review.
- **Present the results** :— use Power BI to communicate the performance overview, profitability diagnostics, and action plan.

## Dashboard Pages
- Retail Performance Overview : 
Summarizes the main business KPIs and presents sales/profitability trends and category/channel performance.
<img width="1072" height="685" alt="Overview" src="https://github.com/user-attachments/assets/31a493ad-a357-46c5-bed9-efa8e089363d" />

- Profitability & Discount Analysis :
Compares category gross margins, discount depth versus gross margin, and SKU-level sales versus profitability.
<img width="1066" height="677" alt="Profit and Discount" src="https://github.com/user-attachments/assets/b0186fd9-2a9c-4bd1-b6d6-dcb3552df09d" />

- Profit Leakage Action Plan
Highlights deep-discount segments, negative-margin patterns, and products requiring targeted investigation rather than assuming that higher sales necessarily mean stronger profitability.
<img width="1076" height="672" alt="Action" src="https://github.com/user-attachments/assets/5b6e6767-ee60-42f1-afc8-8ab350d89035" />

## Key Metrics and Findings
The figures below are reported by the current SQL view and Power BI dashboard. They are expressed in the dataset's reporting units.

| KPI | Reported result |
|---|---:|
| Net Sales | 73.21M |
| Units Sold | 1.68M |
| Gross Profit | 21.10M |
| Gross Margin | 28.82% |
| Discount Rate | 6.50% |

## Diagnostic Findings
- The 21% and higher discount segment generated 5.31M in sales at 9.58% gross margin.
- The 31% and higher discount band showed a reported gross margin of -2.28%.
- Personal Care had the lowest reported category gross margin at 25.86%.
- The analysis also identified SKU-level cases with negative gross profit for review.

## Recommendations for Business Review
Based on the observed results, the analysis recommends that a retail team:
- Review deep-discount guardrails, especially discount bands associated with materially lower or negative gross margins.
- Investigate negative-gross-profit and low-margin SKUs before increasing promotional exposure.
- Review category-level product economics, with attention to the lower-margin categories.
- Validate pricing and cost inputs for the products driving the largest margin gaps.
- Use inventory-risk indicators as a separate operational review, aligning any inventory action with the relevant stock and demand evidence.

## Key Analytical Decisions and Limitations
The project is designed to answer one central business question: Where should the business investigate potential profit leakage, and what actions are supported by the available evidence?
- Focus on gross profitability: The analysis examines gross profit and gross margin across discount bands, categories, and SKUs to identify areas that may need review.
- Validate before interpreting: SQL checks cover row counts, SKU keys and relationships, relevant nulls, value consistency, and price/discount calculations. The source sales table and enriched view each returned 641,843 rows in the reported reconciliation, and the tested sales-to-SKU join had no unmatched SKU records.
- Use consistent KPI calculations: Gross margin is calculated as total gross profit divided by total net sales. Discount rate is calculated from aggregated discount amount divided by aggregated gross list value. These ratios are not calculated by simply averaging row-level percentages.
- Treat findings as diagnostic signals: The 21%+ discount segment generated 5.31M in sales at 9.58% gross margin, while the 31%+ discount band showed -2.28% gross margin. These results support reviewing discount practices and product economics; they do not prove that discounts alone caused low or negative margins.
- Be clear about the dataset grain: A definitive sales-table grain and confirmed unique transaction identifier were not established. For that reason, 641,843 is reported as the number of sales rows, not as a count of unique transactions. Similar-looking rows are not automatically removed without a reliable business key.
- Do not overstate profitability or impact: Gross profit is not net profit and excludes costs not represented in the dataset. Recommendations are proposed actions for business review, not claims that a company implemented them or achieved a measured profit increase.

## Summary
Retail Profit Leakage & Operational Analytics demonstrates a practical analytics workflow using PostgreSQL, SQL, and Power BI: validate the data, prepare an analytical view, examine profitability and discount patterns, communicate the findings, and recommend focused business reviews. The emphasis is on transparent metric definitions, defensible conclusions, and actionable analysis rather than unsupported claims of business impact.
