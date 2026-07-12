# sql_practice
# Advanced SQL Analytics & Schema Design

Welcome to the SQL Practice Sandbox repository. This project showcases a robust, production-like database schema involving core operational domains: 
Human Resources (Employees & Departments) and E-commerce (Orders & Sales Tracking).

The primary purpose of this project is to demonstrate proficiency in writing clean, optimized, and complex SQL queries—ranging from window functions and recursive-style self-joins to Common Table Expressions (CTEs) and conditional aggregations.

#📊 Database Schema Overview

The repository sets up three highly relational tables designed to simulate realistic business scenarios:

department1: Manages company departments and physical geographic locations.

employees1: Stores operational employee data, handling salary structures, hiring timelines, and a self-referencing hierarchy (manager_id pointing to emp_id).

orders1: Tracks day-to-day e-commerce transactional sales data.

#🚀 Key Analytics Solved

The script contains production-ready solutions for complex analytical problems often requested by executive business leadership:

1. Self-Joins & Organizational Hierarchies
2. 
Manager Performance Check: Identified employees earning a higher salary than their direct managers.

Root-Node Mapping: Tracked top-level organizational leaders (employees who do not report to anyone).

Direct Reports Aggregation: Extracted managers managing multi-person teams utilizing LEFT JOIN and HAVING filters.


2. Deep Financial & Departmental Reporting
   
Budget Expenditure Breakdown: Leveraged LEFT JOIN combined with CASE WHEN logic to calculate the total salary budget allocation per department—ensuring empty departments reflect a clean 0.00 balance instead of NULL.

Cross-Average Anomalies: Wrote two variations (Subquery vs. Windowed Analytical Function) to discover individuals earning above their specific department's average baseline.


3. Advanced Window Functions & Business Intelligence
   
Top-N Ranking (Salary Distribution): Implemented RANK() OVER (PARTITION BY ...) to surface the top 2 highest-paid employees per department, cleanly handling salary ties.

Daily Cohort Growth Rate: Utilized the LAG() analytical function to calculate a day-over-day tracking system comparing current_day_sales against previous_day_sales to capture structural revenue growth.

Fresh-Hire Tracking: Isolated the absolute newest additions to the workforce globally across all structural departments using chronological rank scaling.
