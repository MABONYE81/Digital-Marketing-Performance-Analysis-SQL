-- =====================================================================
-- Greenside Villas — Analytical Queries
-- Portfolio Section 2: SQL (joins, CTEs, window functions)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Q1. UNIFIED WEEKLY VIEW (multi-table LEFT JOIN)
-- Combine all four channels into one row per week for cross-channel analysis.
-- ---------------------------------------------------------------------
CREATE VIEW IF NOT EXISTS weekly_unified AS
SELECT
    f.week_date,
    f.reach                       AS fb_reach,
    f.engagements                 AS fb_engagements,
    i.reach                       AS ig_reach,
    i.engagements                 AS ig_engagements,
    w.visitors                    AS site_visitors,
    w.conversions                 AS site_conversions,
    a.views                       AS airbnb_views,
    a.bookings                    AS airbnb_bookings,
    a.revenue                     AS airbnb_revenue
FROM facebook_weekly f
LEFT JOIN instagram_weekly i ON i.week_date = f.week_date
LEFT JOIN website_weekly   w ON w.week_date = f.week_date
LEFT JOIN airbnb_weekly    a ON a.week_date = f.week_date;

SELECT * FROM weekly_unified ORDER BY week_date LIMIT 10;


-- ---------------------------------------------------------------------
-- Q2. MONTHLY ROLLUP (CTE + date bucketing)
-- Rebuild the Excel "Monthly Summary" tab purely in SQL.
-- ---------------------------------------------------------------------
WITH monthly AS (
    SELECT
        strftime('%Y-%m', week_date) AS month,
        SUM(fb_reach)         AS fb_reach,
        SUM(ig_reach)         AS ig_reach,
        SUM(site_visitors)    AS site_visitors,
        SUM(airbnb_views)     AS airbnb_views,
        SUM(airbnb_bookings)  AS bookings,
        SUM(airbnb_revenue)   AS revenue
    FROM weekly_unified
    GROUP BY month
)
SELECT * FROM monthly ORDER BY month;


-- ---------------------------------------------------------------------
-- Q3. MONTH-OVER-MONTH GROWTH (CTE + LAG window function)
-- ---------------------------------------------------------------------
WITH monthly AS (
    SELECT
        strftime('%Y-%m', week_date) AS month,
        SUM(fb_reach)      AS fb_reach,
        SUM(airbnb_revenue) AS revenue
    FROM weekly_unified
    GROUP BY month
)
SELECT
    month,
    fb_reach,
    LAG(fb_reach) OVER (ORDER BY month)  AS prev_month_reach,
    ROUND(
        100.0 * (fb_reach - LAG(fb_reach) OVER (ORDER BY month))
        / NULLIF(LAG(fb_reach) OVER (ORDER BY month), 0), 1
    ) AS fb_reach_mom_pct,
    revenue,
    SUM(revenue) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS revenue_running_total
FROM monthly
ORDER BY month;


-- ---------------------------------------------------------------------
-- Q4. RANKING MONTHS BY REVENUE (RANK / DENSE_RANK window functions)
-- ---------------------------------------------------------------------
WITH monthly_rev AS (
    SELECT strftime('%Y-%m', week_date) AS month, SUM(revenue) AS revenue
    FROM airbnb_weekly
    GROUP BY month
)
SELECT
    month,
    revenue,
    RANK()       OVER (ORDER BY revenue DESC) AS revenue_rank,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_dense_rank
FROM monthly_rev
ORDER BY revenue_rank
LIMIT 10;


-- ---------------------------------------------------------------------
-- Q5. 4-WEEK MOVING AVERAGE OF FACEBOOK REACH (window frame)
-- Smooths weekly noise to see the underlying trend.
-- ---------------------------------------------------------------------
SELECT
    week_date,
    reach,
    ROUND(AVG(reach) OVER (
        ORDER BY week_date
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ), 1) AS reach_4wk_moving_avg
FROM facebook_weekly
ORDER BY week_date
LIMIT 15;


-- ---------------------------------------------------------------------
-- Q6. BOOKING FUNNEL BY MONTH (CTE + conversion math)
-- ---------------------------------------------------------------------
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
    ROUND(100.0 * total_bookings  / NULLIF(total_views, 0), 2)     AS view_to_booking_pct,
    total_revenue
FROM funnel
ORDER BY month;


-- ---------------------------------------------------------------------
-- Q7. WHICH CHANNEL "LEADS" A BOOKING WEEK? (self-join style comparison)
-- For every week with at least one booking, show reach/traffic on all
-- channels that same week, to eyeball which channel was active.
-- ---------------------------------------------------------------------
SELECT
    week_date,
    fb_reach,
    ig_reach,
    site_visitors,
    airbnb_views,
    airbnb_bookings,
    airbnb_revenue
FROM weekly_unified
WHERE airbnb_bookings > 0
ORDER BY week_date;


-- ---------------------------------------------------------------------
-- Q8. TOP 5 BEST AND WORST WEEKS BY WEBSITE TRAFFIC (UNION + window function)
-- ---------------------------------------------------------------------
WITH ranked AS (
    SELECT
        week_date,
        visitors,
        ROW_NUMBER() OVER (ORDER BY visitors DESC) AS rank_desc,
        ROW_NUMBER() OVER (ORDER BY visitors ASC)  AS rank_asc
    FROM website_weekly
)
SELECT week_date, visitors, 'TOP 5' AS category FROM ranked WHERE rank_desc <= 5
UNION ALL
SELECT week_date, visitors, 'BOTTOM 5' AS category FROM ranked WHERE rank_asc <= 5
ORDER BY category, visitors DESC;
