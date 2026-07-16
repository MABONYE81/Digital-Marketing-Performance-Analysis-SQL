-- =====================================================================
-- Greenside Villas — Digital Marketing & Booking Data Warehouse
-- Portfolio Section 2: SQL
-- Engine: SQLite (portable; ports to Postgres/MySQL with minor type tweaks)
-- =====================================================================

DROP TABLE IF EXISTS facebook_weekly;
DROP TABLE IF EXISTS instagram_weekly;
DROP TABLE IF EXISTS website_weekly;
DROP TABLE IF EXISTS airbnb_weekly;
DROP TABLE IF EXISTS tourism_context;

-- Weekly Facebook page performance
CREATE TABLE facebook_weekly (
    week_date        DATE PRIMARY KEY,
    followers        INTEGER,
    new_followers    INTEGER,
    posts            INTEGER,
    engagements      INTEGER,   -- likes + comments + shares
    reach            INTEGER,
    impressions      INTEGER,
    clicks           INTEGER,
    conversions      INTEGER,
    reviews          INTEGER
);

-- Weekly Instagram performance
CREATE TABLE instagram_weekly (
    week_date        DATE PRIMARY KEY,
    followers        INTEGER,
    new_followers    INTEGER,
    posts            INTEGER,
    engagements      INTEGER,
    reach            INTEGER,
    impressions      INTEGER,
    clicks           INTEGER,
    conversions      INTEGER
);

-- Weekly website analytics
CREATE TABLE website_weekly (
    week_date        DATE PRIMARY KEY,
    visitors         INTEGER,
    page_views       INTEGER,
    bounce_rate      REAL,      -- stored as fraction, e.g. 0.34 = 34%
    avg_session_min  REAL,
    conversions      INTEGER,
    new_page_views   INTEGER
);

-- Weekly Airbnb listing performance (the revenue-generating channel)
CREATE TABLE airbnb_weekly (
    week_date        DATE PRIMARY KEY,
    listing_name     TEXT,
    views            INTEGER,
    inquiries        INTEGER,
    bookings         INTEGER,
    nights_booked    INTEGER,
    revenue          REAL,
    occupancy_rate   REAL,
    conversion_rate  REAL
);

-- Annual market context (Tanzania tourist arrivals)
CREATE TABLE tourism_context (
    year                      INTEGER PRIMARY KEY,
    tourist_arrivals_millions REAL,
    notes                     TEXT
);

CREATE INDEX idx_fb_date  ON facebook_weekly(week_date);
CREATE INDEX idx_ig_date  ON instagram_weekly(week_date);
CREATE INDEX idx_web_date ON website_weekly(week_date);
CREATE INDEX idx_ab_date  ON airbnb_weekly(week_date);
