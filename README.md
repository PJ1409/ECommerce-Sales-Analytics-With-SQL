# E-Commerce Sales Analysis 

#### Author Name: Pallavi Jagare


# Project Overview

This project analyzes an ecommerce dataset to understand revenue performance, order behavior, and customer value. The analysis was built using PostgreSQL, with SQL developed and tested in VS Code using SQLTools.

The project translates three business questions into data-driven findings: How is the business performing? What is driving revenue changes? And which customers contribute the most value? The analysis focuses on delivered orders and covers 10,000 customers and 40,000 orders in the available dataset.

The goal is not just to produce SQL queries, but to turn raw transactional data into findings that can support business and marketing decisions.

# Key Business Insights

## 1. Revenue changes were primarily volume-driven

Delivered revenue increased from $35.70M in March to $66.62M in April, an 86.58% increase, before declining to $38.05M in May.

Average Order Value remained relatively stable at approximately $7.45K–$7.64K across March–May. This indicates that changes in order volume had a larger impact on monthly revenue than changes in average basket value.

Note: March and June are partial months and should not be directly compared with full months.

## 2. Returning customers generate most of the revenue

Repeat and VIP customers represent only 30.18% of the customer base but contribute 84.61% of delivered revenue.

VIP customers alone represent 11.25% of customers but generate 56.85% of delivered revenue.

This concentration makes customer retention and continued engagement important areas for marketing consideration.

## 3. Customer Value by Segment

| Segment        | Customers | % Customers | Revenue  | % Revenue | Avg. Orders | Avg. Lifetime Spend  |
|----------------|-----------|-------------|----------|-----------|-------------|----------------------|
| VIP Buyer      | 1,125     | 11.25%      | $85.51M  | 56.85%    | 10.19       | $76,007.30           |
| Repeat Buyer   | 1,893     | 18.93%      | $41.76M  | 27.76%    | 2.89        | $22,059.42           |
| One-Time Buyer | 3,034     | 30.34%      | $23.15M  | 15.39%    | 1.00        | $7,630.70            |

Customer Segmentation Framework

Customers were segmented using the number of delivered orders during the analysis period:
- No order = 0 delivered orders
- One Time Buyer = 1 delivered order
- Repeat Buyer = 2-4 delivered orders
- VIP Buyer = 5+ delivered orders

Segment	Definition

Repeat Buyers have 2.89× the average lifetime spend of One-Time Buyers, while VIP Buyers have 9.96× the average lifetime spend.

#  Business Questions

## Revenue & Business Health
What is the delivered revenue trajectory?
How does Average Order Value change over time?
Are revenue changes driven by order volume or order value?
Finding: Revenue fluctuates substantially by month while AOV remains relatively stable, suggesting that order volume is the primary driver of the observed monthly revenue changes.

[Read Detailed Business Health Analysis](./findings/01_Business_Health.md)

## Customer Segmentation
What proportion of customers purchase once versus repeatedly?
How much revenue does each customer segment contribute?
Which customer segment has the highest lifetime value?
Finding: A relatively small group of Repeat and VIP customers contributes the majority of delivered revenue.

[Read Detailed Customer Segment Analysis](./findings/03_Customer_Segment.md)

## Repository Structure

- SQL
  - 01_exploration.sql
  - 02_revenue.sql
  - 03_customers.sql
- Findings
  - executive_summary.md
  - business_health.md
  - customer_segments.md
  - README.md

# Tools Used
- PostgreSQL
- SQL
- Common Table Expressions (CTEs)
- Window Functions
- Aggregate Functions
- Joins
- Conditional Aggregation
- Git & GitHub


