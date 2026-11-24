# Retail-Sales-Analysis
Analysis of Sales Data to Build Business Report
Retail Sales Performance Analysis (SQL)
Project Overview
This project analyses retail sales data to evaluate business performance, identify profitability trends, understand customer behaviour, and generate actionable business recommendations using SQL Server.
The analysis focuses on sales performance across product categories, regions, customers, discounts, shipping methods, and time periods.
Business Objectives
• Evaluate overall sales and profitability.
• Identify the best- and worst-performing product categories.
• Compare regional sales and profit performance.
• Analyse the relationship between discount levels and profitability.
• Evaluate monthly and annual sales trends.
• Identify high-performing and loss-making products.
• Understand customer purchasing patterns and profitability.
• Segment customers according to their sales contribution.
Tools and Technologies
• Microsoft SQL Server
• SQL Server Management Studio (SSMS)
• SQL
Dataset
The project uses the Sample Superstore dataset.
The dataset contains retail transaction records covering 2014–2017, including:
• Order and shipping dates
• Customer information
• Product categories and sub-categories
• Sales and profit
• Quantity and discount
• Regional information
The analysis was conducted using the dbo.Superstore_cleaned table in the RetailSalesDB database.
SQL Analysis Performed
1. Data quality checks
2. Overall business KPIs
3. Product category performance
4. Regional performance
5. Discount analysis
6. Monthly sales and profit trends
7. Year-over-year performance analysis
8. Product performance analysis
9. Customer performance analysis
10. Shipping performance analysis
11. Sub-category analysis
12. Customer segmentation
Key Findings
• Total sales were approximately 2.30 million.
• Total profit was approximately 286,410.
• The business recorded 5,008 distinct orders and 793 customers.
• Technology generated the highest sales and profit among product categories.
• The West region recorded the highest sales and profit.
• Furniture had a relatively low profit margin compared with other categories.
• Medium and high discount groups recorded negative profits.
• Sales increased significantly in 2016 and 2017.
• Canon imageCLASS 2200 Advanced Copier was the highest-performing product by sales and profit.
• Copiers was the most profitable sub-category, while Tables recorded a cumulative loss.
• Tamara Chand was the highest-selling and highest-profit customer.
• 152 customers recorded negative cumulative profitability.
• Customer segmentation showed that Medium Value customers generated the highest total sales, while High Value customers generated the highest total profit.
Business Recommendations
• Review pricing and cost structures in low-margin product categories.
• Reassess discount policies, particularly for heavily discounted products.
• Investigate regional differences in profitability.
• Maintain strong relationships with high-value customers.
• Develop targeted campaigns to encourage medium-value customers to increase their spending.
• Investigate loss-making products and sub-categories before making inventory or pricing decisions.
Project Structure
Retail-Sales-SQL-Project/
│
├── Retail_Sales_Performance_Analysis.sql
├── Retail_Sales_Business_Findings.docx
└── README.md
Conclusion
This project demonstrates the application of SQL Server in transforming retail transaction data into meaningful business insights.
Through data aggregation, customer segmentation, trend analysis, and profitability evaluation, the project identifies important performance patterns and provides recommendations to support better business decisions.
Skills Demonstrated
• SQL querying and data aggregation
• Common Table Expressions (CTEs)
• Window functions
• Data analysis and business intelligence
• Customer segmentation
• Trend and profitability analysis
• Business interpretation and reporting
