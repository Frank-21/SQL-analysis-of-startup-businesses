select * from [Tech 1M Project].[dbo].[acquisitions]
select * from [Tech 1M Project].[dbo].[countries]
select * from [Tech 1M Project].[dbo].[degrees]
select * from [Tech 1M Project].[dbo].[funding_rounds]
select * from [Tech 1M Project].[dbo].[funds]
select * from [Tech 1M Project].[dbo].[investments]
select * from [Tech 1M Project].[dbo].[ipos]
select * from [Tech 1M Project].[dbo].[milestones]
select * from [Tech 1M Project].[dbo].[objects]
select * from [Tech 1M Project].[dbo].[offices]
select * from [Tech 1M Project].[dbo].[people]
select * from [Tech 1M Project].[dbo].[relationships]

use [Tech 1M Project]

---- ANSWERS ----

--- Main Tasks
-- 1. Biotech companies received most of the fundings meaning that there are more public trust that
-- biotech companies will have most return on investment ---

--- 2. The United States recieved most funding out of all the countries followed by the UK ---

--- REASON FOR MY INSIGHTS: I believe any stakeholder hoping to invest and avoid unnecessary risk
--- should invest in a biotech company in the US or UK and be certain of ROI 

--- QUESTIONS FROM DATASETS ---

---- 1. Edita Food Industries in Egypt received the largest investment (funding) out of all African startups -----
----- Edita Food Industries	received a total sum of 102,000,000.00

----2. the level of degree had no impact on the size of founding rounds ----
----- the funding cut across different academic qualification in no particular order ----
--- this data clearly suggests that 'type of startup' was the criteria for funding not 'level of degree' ----

-----2A. Facebook had the most funding rounds (11), and it's founder "Mark Zuckerberg" attended Harvard University
-----2B. 26 founders attended the Harvard University.

----- 3. SF Bay region in the US had the most startups
------4. Facebook is the startup with the most funding round
------4A. Mark Zuckerberg is the founder of Facebook.



--- ACQUISITION EDA----

-- Acquisition Time Series Analysis showing an increase in the acqisition of startups yearly--

SELECT
  FORMAT(acquired_at, 'yyyy') as acquisition_year
  ,COUNT(acquired_object_id) as total_startups_acquired
  ,SUM(price_amount) as acquisition_value
  FROM [Tech 1M Project].[dbo].[acquisitions]
  group by FORMAT(acquired_at, 'yyyy')
  order by FORMAT(acquired_at, 'yyyy') desc

 -- Shows the total amount spent by companines on already acquired investments

 SELECT 
 objects.name as company_name, 
 SUM(acquisitions.price_amount) as Total_amount_spent_on_acquisition
 FROM [Tech 1M Project].[dbo].[objects]
 JOIN
 [Tech 1M Project].[dbo].[acquisitions]
 ON
 objects.object_id = acquisitions.acquired_object_id
 group by objects.name
 order by SUM(acquisitions.price_amount) desc

 -- Shows the total amount spent by companines on acquiring investments

 SELECT 
 objects.name as company_name, 
 SUM(acquisitions.price_amount) as Total_amount_spent_on_acquisition
 FROM [Tech 1M Project].[dbo].[objects]
 JOIN
 [Tech 1M Project].[dbo].[acquisitions]
 ON
 objects.object_id = acquisitions.acquiring_object_id
 group by objects.name
 order by SUM(acquisitions.price_amount) desc

  --- FUNDING_ROUND EDA----

  -- Shows the various amount raised from funding each year, though it is not consistently increasing each year, 
  --- but generally there is an increment in funding in recent years.

    SELECT
  FORMAT(funded_at, 'yyyy') as funding_year
  ,SUM(raised_amount_usd) as raised_amount_usd
  FROM [Tech 1M Project].[dbo].[funding_rounds]
  group by FORMAT(funded_at, 'yyyy')
  order by SUM(raised_amount_usd) desc

  -- Shows the yearly total funding round and the amount raised

  SELECT
  FORMAT(funded_at, 'yyyy') as funding_year
  ,COUNT(funding_round_type) as total_funding_round_type
  ,SUM(raised_amount_usd) as funding_raised_usd
  FROM [Tech 1M Project].[dbo].[funding_rounds]
  group by FORMAT(funded_at, 'yyyy')
  order by SUM(raised_amount_usd) desc

  -- Shows the amount raised from each funding round type and the number of participants over the years

  SELECT funding_round_type
  ,SUM(participants) as Num_of_Participants
  ,SUM(raised_amount_usd) as funding_raised_usd
  FROM [Tech 1M Project].[dbo].[funding_rounds]
  group by funding_round_type
  order by SUM(raised_amount_usd) desc

  -- IPOS EDA---

  -- Shows the valuation in USD of each stock symbol, and the year it went public

 SELECT stock_symbol
 ,valuation_amount
 ,FORMAT(public_at, 'yyyy') as IPO_year
  FROM [Tech 1M Project].[dbo].[ipos]
  where FORMAT(public_at, 'yyyy') is not null and valuation_amount > 0
  order by FORMAT(public_at, 'yyyy') desc
  
  --- Shows the Top valued companies and their IPOS year

  SELECT objects.name as company_name,  ipos.valuation_amount, ipos.raised_amount, 
  FORMAT(ipos.public_at, 'yyyy') as IPOS_year
  FROM [Tech 1M Project].[dbo].[objects]
  JOIN
  [Tech 1M Project].[dbo].[ipos]
  ON
  objects.object_id = ipos.object_id
  where raised_amount > 0
   order by valuation_amount desc

   --OBJECTS EDA

   ---shows that only companies that received fundings out of all types of startups

 SELECT 
entity_type as type_of_startups,
SUM(funding_total_usd) as total_funds_received
 FROM [Tech 1M Project].[dbo].[objects]
 group by entity_type
 order by SUM(funding_total_usd) desc


 --- shows Categories of startups that participated in the most funding rounds---

SELECT 
category_code as Category_of_startups,
COUNT(funding_rounds) as total_funds_rounds
FROM [Tech 1M Project].[dbo].[objects]
where category_code is not null
group by category_code
order by COUNT(funding_rounds) desc

   --- Shows the Categories of startups that received the most fundings--- 
   ----- Biotech companies received the most funds even though software companies participated in most finding rounds----

SELECT 
category_code as Category_of_startups,
COUNT(category_code) as num_of_startups,
SUM(funding_total_usd) as total_funds_received
 FROM [Tech 1M Project].[dbo].[objects]
 group by category_code
 order by total_funds_received desc

  ---shows the name of startups and type of startups, the category they belong to and their current status either acquired or operating ----

 SELECT 
name as name_of_company,
entity_type as type_of_startups,
category_code as Category_of_startups,
status 
 FROM [Tech 1M Project].[dbo].[objects]

 --- shows the amount of funds received by each biotech company and their current status 

 SELECT 
name as name_of_company,
category_code as Category_of_startups,
status, (funding_total_usd) as total_funds_received
 FROM [Tech 1M Project].[dbo].[objects]
where [Tech 1M Project].[dbo].[objects].category_code = 'biotech'
order by funding_total_usd desc
  
--- shows the countries with most startups (United states had the most startups, followed by the UK)----

SELECT countries.country_name, 
COUNT(countries.country_name) as max_num_of_startups
from [Tech 1M Project].[dbo].[countries]
JOIN
[Tech 1M Project].[dbo].[objects]
ON
objects.country_code = countries.country_code
group by countries.country_name
order by COUNT(countries.country_name) desc

--- shows the countries that reeceived the most FUNDING (United states had the most funding, followed by the UK)----

SELECT countries.country_name, 
COUNT(countries.country_name) as num_of_startups,
SUM(objects.funding_total_usd) as total_funds_received
from [Tech 1M Project].[dbo].[countries]
JOIN
[Tech 1M Project].[dbo].[objects]
ON
objects.country_code = countries.country_code
group by countries.country_name
order by SUM(objects.funding_total_usd) desc

--- shows the countries that participated in the most FUNDING rounds (United states participated in the most FUNDING rounds, followed by the UK)----

SELECT countries.country_name, 
COUNT(objects.funding_rounds) as total_funding_rounds
from [Tech 1M Project].[dbo].[countries]
JOIN
[Tech 1M Project].[dbo].[objects]
ON
objects.country_code = countries.country_code
group by countries.country_name
order by COUNT(objects.funding_rounds) desc

--- African countries that had the most startups ----

SELECT countries.country_name, 
COUNT(countries.country_name) as max_num_of_startups
from [Tech 1M Project].[dbo].[countries]
JOIN
[Tech 1M Project].[dbo].[objects]
ON
objects.country_code = countries.country_code
where countries.region = 'africa'
group by countries.country_name
order by COUNT(countries.country_name) desc

--- African countries that had the most fundings, Egypt had the most funding even though they did not have the most number of startups ----

SELECT countries.country_name,
COUNT(countries.country_name) as num_of_startups,
SUM(objects.funding_total_usd) as total_funds_received
from [Tech 1M Project].[dbo].[countries]
JOIN
[Tech 1M Project].[dbo].[objects]
ON
objects.country_code = countries.country_code
where countries.region = 'africa'
group by countries.country_name
order by SUM(objects.funding_total_usd) desc

--- South Africa participated in the most funding rounds in Africa----

SELECT 
countries.country_name, 
COUNT(objects.funding_rounds) as total_funding_rounds
from [Tech 1M Project].[dbo].[countries]
JOIN
[Tech 1M Project].[dbo].[objects]
ON
objects.country_code = countries.country_code
where countries.region = 'africa'
group by countries.country_name
order by COUNT(objects.funding_rounds) desc

--- (QUESTION 1 FROM DATASET) ---
---Shows that Edita Food Industries in Egypt received the largest investment (funding) out of all African startups -----
----- Edita Food Industries	received a total sum of 102,000,000.00

SELECT countries.country_name,
objects.name as name_of_startup,
funding_total_usd as total_funds_received_usd
from [Tech 1M Project].[dbo].[objects]
JOIN
[Tech 1M Project].[dbo].[countries]
ON
objects.country_code = countries.country_code
where countries.region = 'africa'
order by funding_total_usd desc

--- (QUESTION 3) SF Bay region had the most startups ----

SELECT 
objects.region,
COUNT(objects.name) as num_of_startups
from [Tech 1M Project].[dbo].[objects]
where objects.region != 'unknown'
group by objects.region
order by COUNT(objects.name) desc

--- SF Bay region received the most funding ----

SELECT 
region,
COUNT(name) as num_of_startups,
sum(funding_total_usd) as total_funds_received_usd
from [Tech 1M Project].[dbo].[objects]
where objects.region != 'unknown'
group by objects.region
order by sum(funding_total_usd) desc

--- (QUESTION 2A) showing that the level of degree had no impact on the size of founding rounds ----
----- the funding cut across different academic qualification in no particular order ----
--- this data clearly suggests that 'type of startup' was the criteria for funding not 'level of degree' ----

SELECT 
degrees.degree_type as level_of_degree,
COUNT(objects.funding_rounds) as funding_rounds
FROM [Tech 1M Project].[dbo].[degrees]
JOIN
[Tech 1M Project].[dbo].[objects]
ON
degrees.object_id = objects.object_id
where degrees.degree_type is not null
GROUP BY degrees.degree_type
order by COUNT(objects.funding_rounds) desc

--- (QUESTION 4A) Showing the startup with the most founding rounds = Facebook, and Founders name = Mark Zuckerberg

SELECT 
people_view.name_of_founder,
objects.name as name_of_startup,
objects.category_code as Category_of_startups,
objects.status, objects.funding_rounds as total_funding_rounds
FROM [Tech 1M Project].[dbo].[objects]
JOIN
[Tech 1M Project].[dbo].[people_view]
ON
objects.name = people_view.affiliation_name
where objects.funding_rounds != 0
order by total_funding_rounds desc

---- (QUESTION 2A) What university did the founder that has the most funding rounds attend = Harvard University ---

SELECT
people_view.name_of_founder,
degrees.institution
FROM [Tech 1M Project].[dbo].[degrees]
JOIN
[Tech 1M Project].[dbo].[people_view]
ON
degrees.object_id = people_view.object_id
where people_view.name_of_founder = 'Mark Zuckerberg'

--- (QUESTION 2Bi) How many founders attended the Harvard University = 26 founders (minus duplicates) ---

SELECT
people_view.name_of_founder,
degrees.institution
FROM [Tech 1M Project].[dbo].[degrees]
JOIN
[Tech 1M Project].[dbo].[people_view]
ON
degrees.object_id = people_view.object_id
where degrees.institution = 'Harvard University'

---		(QUESTION 2Bii) -how many founders that attended Harvard University have an IPO  = zero (0)



  