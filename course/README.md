# 🎓 Advanced SQL Course: Mastery with Oracle 23ai

Welcome to the **Advanced SQL Course**. This program is designed for developers and data analysts who want to move beyond basic CRUD operations and master the high-performance features of the Oracle Database. 

Using the **`vuelos` (Aviation)** dataset, we will solve real-world business problems using the latest techniques in Oracle 23ai

---

## 🛠️ Environment & Prerequisites

To follow this course, you will need:
*   **Database:** Oracle Database 23ai (Free/Developer Edition).
*   **IDE:** Visual Studio Code.
*   **Extension:** [Oracle SQL Developer Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=Oracle.sql-developer).
*   **Dataset:** The `vuelos` schema (pre-loaded with flights, reservations, and passenger data, can be downloaded from [here](https://github.com/CafeDatabase/vuelos-dataset).

---

## 📚 Course Modules

### [Module 1: Analytic & Window Functions](./Module_1.sql)
Master calculations across rows without self-joins.
*   Ranking (`RANK`, `DENSE_RANK`, `ROW_NUMBER`).
*   Navigational functions (`LAG`, `LEAD`).
*   Running totals and moving averages with `OVER()`.

### [Module 2: Common Table Expressions (CTEs)](./Module_2.sql)
Write cleaner code and solve hierarchical problems.
*   Query organization and readability.
*   Recursive CTEs for multi-leg flight connections.
*   Generating virtual data series (date calendars).

### [Module 3: Advanced Reporting](./Module_3.sql)
Generate executive-level summaries directly in SQL.
*   Hierarchical subtotals with `ROLLUP`.
*   Cross-dimensional analysis with `CUBE`.
*   Data rotation for dashboards using `PIVOT`.

### [Module 4: Performance & Data Manipulation](./Module_4.sql)
Optimize and extend your database's capabilities.
*   Complex pattern matching with Regular Expressions.
*   Calculated fields using **Virtual Columns**.
*   Caching results with **Materialized Views**.

### [Module 5: Data Recovery & Security](./Module_5.sql)
Protect your data and "travel through time."
*   Restoring accidentally changed data with **Flashback Query**.
*   Granular row-level security concepts (**VPD**).
*   Data masking and redaction.

---

## 🎁 Bonus Lessons

*   **Bonus A: Oracle 23ai JSON Power:** Learn how to store and query native JSON data alongside relational tables.
*   **Bonus B: The "Undo" Button:** Deep dive into Flashback Table and Flashback Drop (Recycle Bin).

---

## 🏁 The Final Challenge
Complete the **Executive Performance Report** to earn your completion. You will combine recursion, window functions, and data masking to build a multi-page business intelligence report from scratch.

---

## 💡 How to use this Course (SQL Notebooks)
Each module is provided as a `.sql` file designed for **SQL Notebooks** in VS Code:
1.  Open the `.sql` file in VS Code.
2.  Ensure your **Oracle SQL Developer** extension is connected to the `vuelos` schema.
3.  Use the **"Run in Notebook"** interface to execute code blocks individually and see results immediately below the documentation.

---
*Happy Querying!* ✈️
