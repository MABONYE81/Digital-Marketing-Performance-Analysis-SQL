# 02_SQL — README

## Is there a dashboard here? No — and that's normal.
SQL is a **query language**, not a visualization tool. Running a query gives
you a table of numbers (rows and columns), not a chart or dashboard. If you
want the visual version of this same data, that's what `03_Python`
(charts) and `06_Tableau` / `07_PowerBI` (dashboards) are for — all three
use these exact same numbers.

Think of it like this: SQL is the kitchen where the data gets prepared;
the dashboard tools are the plate it gets served on. This folder is the
kitchen.

## What you'll actually see when you run this
A grid of rows and columns — e.g. running the funnel query shows you a
table like:

| month | total_views | total_inquiries | total_bookings |
|---|---|---|---|
| 2025-01 | 42 | 0 | 0 |
| 2025-02 | 38 | 1 | 1 |
| ... | | | |

That's the correct, expected output for a SQL query.

## How to open and run this, step by step
1. Install **DB Browser for SQLite** (free): https://sqlitebrowser.org
   — download the version for your OS (Windows/Mac/Linux), install it
   normally.
2. Open the app. Go to **File → Open Database** and select `03_greenside.db`
   from this folder.
3. Click the **"Browse Data"** tab at the top — this lets you click through
   each table (facebook_weekly, instagram_weekly, website_weekly,
   airbnb_weekly, tourism_context) and see the raw rows, like a spreadsheet.
4. Click the **"Execute SQL"** tab. This is where you actually run queries.
5. Open `02_queries.sql` in a plain text editor (Notepad, TextEdit, VS Code
   — anything), copy one query at a time (they're separated by comment
   headers like `-- Q1. ...`), paste it into the Execute SQL tab, and click
   the ▷ (Run) button or press Ctrl+Enter / Cmd+Enter.
6. The results table appears at the bottom of the screen.

## Which query to try first
Copy this into the Execute SQL tab and run it — it's the single most useful
query in the file, showing the booking funnel by month:
```sql
WITH funnel AS (
    SELECT
        strftime('%Y-%m', week_date) AS month,
        SUM(views)     AS total_views,
        SUM(inquiries) AS total_inquiries,
        SUM(bookings)  AS total_bookings,
        SUM(revenue)   AS total_revenue
    FROM airbnb_weekly
    GROUP BY month
)
SELECT
    month,
    total_views,
    total_inquiries,
    total_bookings,
    ROUND(100.0 * total_inquiries / NULLIF(total_views, 0), 2)     AS view_to_inquiry_pct,
    ROUND(100.0 * total_bookings  / NULLIF(total_inquiries, 0), 2) AS inquiry_to_booking_pct,
    total_revenue
FROM funnel
ORDER BY month;
```

## Files in this folder
1. `01_schema.sql` — defines the 5 tables (run this first if rebuilding the database from scratch; not needed if you're just using `03_greenside.db` as-is)
2. `02_queries.sql` — 8 ready-to-run analytical queries
3. `03_greenside.db` — the actual database, pre-built and ready to open
4. `04_SQL_Analytics_Report.docx` — write-up of what each query found
5. `05_SQL_Insights_Summary.md` — one-page takeaways
