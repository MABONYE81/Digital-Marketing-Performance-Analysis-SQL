# SQL Section — Key Insights (One-Pager)
**Greenside Villas | Relational Data Model + Query Analysis, Jan 2025–Jun 2026**

## The 4 things that matter

1. **The funnel breaks in one specific place.** Of 742 total Airbnb listing views, only 14 became inquiries (1.89%) — but once someone inquired, 9 of 14 became bookings (64.29%). That's a huge gap between two conversion rates that a single blended "booking conversion rate" would hide.

2. **This means the fix is upstream, not downstream.** Whatever generates an inquiry — listing photos, description, pricing, response speed — already works well. The problem is getting from "view" to "inquiry" at all. More traffic to a listing that converts views at 1.89% just produces more views, not more bookings.

3. **August and July 2025 carried the year.** RANK() over monthly revenue shows these two months alone ($891 + $772) account for more than half of all 18 months of revenue combined — worth understanding what was different about them (seasonality? a specific promotion?) before assuming performance is flat.

4. **Social reach and bookings don't move together.** Looking directly at the 9 weeks that produced a booking, Facebook/Instagram reach on those specific weeks was mostly unremarkable — one week (Apr 25, 2025) had a reach spike, the other eight didn't. Don't assume a reach campaign will show up in bookings.

## Bottom line
This SQL layer sharpens the Excel finding: it's not just "conversion is broken" — it's specifically the **view-to-inquiry step**. That's where the next dollar of effort should go.

*Companion files: `schema.sql`, `queries.sql`, `greenside.db`, `SQL_Analytics_Report.docx`.*
