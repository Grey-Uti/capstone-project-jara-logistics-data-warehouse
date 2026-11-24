
# Capstone Project jara logistics Data Warehouse (10Alytics)
My personal portfolio project to demonstrate the development of a data warehouse solution with Snowflake, DBT, including data modelling, and analytics.

---
## 🚀 Project Requirements

### Buidling a data Warehouse solution for Jara Logistics

## About Jara Logistics
Jara Logistics is a last-mile delivery company in Lagos, Nigeria. Customers order, a rider
collects, a rider delivers. Three thousand three hundred jobs last quarter.
Jara operates across five Nigerian cities, Lagos, Abuja, Port Harcourt, Ibadan and Kano,
with thirty four riders split across two fleets. Twenty are employed directly. Fourteen
belong to an outside partner company, which Jara pays NGN 220 for every kilometre
delivered.
That per-kilometre arrangement is where the trouble started. In December the November
cost report for the partner fleet came back at a figure nobody could explain, Finance
refused to pay it, and eleven weeks later fourteen riders are still waiting.

#### Business Problem

Jara's November cost report for the partner fleet read NGN 127,983,042. October had
been NGN 769,318. Finance suspended all payments pending investigation, which was
the correct thing to do. That was eleven weeks ago, and nobody in the building can
say which number is real.

The challenge has several moving parts. First, nobody has ever profiled
this data, so no one knows what is actually in it. Second, the partner
fleet is paid from the distance column, which means a fault in one
column becomes a fault in a payment. Third, Operations insists trip
volume was normal in November but also says their support queue
that month was the worst they have ever seen, and those two
statements have never been reconciled. Fourth, there is no test
anywhere that would have caught any of this on the day it happened.
The partner company is threatening to withdraw its riders on 1 March,
which would remove roughly forty percent of delivery capacity.


#### Project Objective
Develop a data warehouse solution (dimensional model) to consolidate deliveries, rides and customer data, enabling analytical reporting and informed decision-making.

#### Provided Data
- deliveries.csv
- riders.csv
- customers.csv 
- support_tickets.jsonl


#### Tool stack
- Snowflake
- MongoDB
- Data Build Tool (DBT)


#### Specifications
- **Data Sources**: Import data raw provided as CSV files and JSON file.
- **Data Ingestion**: Load CSV files into snowflake database, and load .jsonl file into MongoDB Database.
- **Data Quality**: Cleanse and resolve data quality issues.
- **Data Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Analytics**: Answer business questions.

---

#### 🌟 About Me
Hi there! My name is **Oghenegare Precious Uti**, and my preferred name is **Gare Precious Uti**. I am a Data pro with specialties in Data analytics and Data engineering.

