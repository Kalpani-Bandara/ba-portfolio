
# Business Analytics Portfolio: Superstore Sales

One dataset, three tools: **Excel, SQL and Power BI**.
Dataset: Superstore Sales (9,994 order lines, 2011 to 2014, US retailer).

## Project 1: Excel Analysis

### Business problem
Which regions, products and discount levels drive profit, and where is the company losing money?

### What I did
- Converted the data into an Excel Table and removed 1 duplicate row (9,993 rows left)
- Checked for blanks (none) and added Order Year and Order Month columns
- Built pivot tables: sales by region and category, monthly trend, top 10 products, profit by sub-category, profit by discount level
- Built a 5-chart dashboard and an XLOOKUP lookup tool
- Used conditional formatting to highlight loss-making order lines

### Key findings
1. Sales grew from about $484K (2011) to $734K (2014), and Q4 is the strongest season.
2. West is the top region ($725K). Technology leads sales ($836K), but Furniture earns only $18K profit on $742K of sales.
3. Tables lose about $17.7K on $207K of sales (-8.6% margin). Bookcases and Supplies also make losses.
4. Every discount level of 30% or more loses money in total.

### Files
- `Excel/Superstore_Analysis.xlsx`: cleaned data, pivots, dashboard
- `Excel/excel_dashboard.png`: dashboard screenshot

## Coming next
- Project 2: SQL
- Project 3: Power BI
