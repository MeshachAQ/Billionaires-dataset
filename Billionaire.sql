--In today's analysis, we want to gain insight in the top billionaires in the world
select * from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

--Our first task is to just retrieve billionaire's name and networth/finalworth. should be easy so..
select personName, finalWorth from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
Order by finalWorth DESC

--Secondly, our manager wants to know all the countries these billionaires are located. Again pretty easy
select distinct country, personName from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---Thirdly, manager wants to know how many different countries we have in this dataset. Again fairly easy

select count(distinct country) as countries from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---now manager wants to know the average networth or average final worth. Again very simple
select avg(finalworth) as average_networth from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---now, manager wants to know the richest person in france where city is not paris
---first, I will want us to look at all the rich people in france s0...
select personName, city, finalWorth from [Billionaires Statistics Dataset - Billionaires Statistics Dataset] where country =  'France'

---now that we have this, let's tackle the main question so where city isnt france, top 1
select top 1 personName, city, finalWorth from [Billionaires Statistics Dataset - Billionaires Statistics Dataset] where country = 'france' and city <> 'Paris'


---Now let's look at richest people in Spain or Germany
select personName, finalWorth, country from [Billionaires Statistics Dataset - Billionaires Statistics Dataset] where country = 'Spain' or country = 'Germany'

---Again, management wants to find the richest people in France, Spain and Germany
---we can probably use or and maybe AND but its not even ideal s0
select personName, country, finalWorth from [Billionaires Statistics Dataset - Billionaires Statistics Dataset] where country IN('France', 'Spain', 'Germany')
order by finalWorth DESC

select * from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---Management now wants to find how many of these billionaires are self made
select count(selfMade) as Number_of_SelfMade_billionares from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
where selfMade = 1

---Now management wants us to find the number of billionaires by industries
select industries, count(personName) as total_persons from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
group by industries

---List the top 10 billionaires by industry
select top 10 personName, industries, finalWorth from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
ORDER BY finalWorth DESC

---Manager again wants to know billionaires by birth month
select birthMonth, count(personName) as total_in_months from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
group by birthMonth



select * from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---Now manager wants to find all countries starting with A
SELECT distinct country from [Billionaires Statistics Dataset - Billionaires Statistics Dataset] where country like 'A%'

---He also wants to find countries ending with the letter D
SELECT distinct country from [Billionaires Statistics Dataset - Billionaires Statistics Dataset] where country like '%d'

--Now the manager wants to test out something by categorising billionaires by high and low per a certain threshhold per final worth
select personName, Country, City, gender, age, birthdate, finalWorth,
CASE
WHEN finalWorth < 100000 THEN 'Low'
Else 'High'
END as Worth_Status from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---We can equally group this into Low, Medium and High per finalworth threshhold
select personName, Country, City, gender, age, birthdate, finalWorth,
CASE
WHEN finalWorth <= 30000 THEN 'Low'
WHEN finalWorth BETWEEN 30000 AND 100000 THEN 'Medium'
Else 'High'
END as Worth_Status from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---Now the manager wants to know the average networth vs each person
select personName, avg(finalWorth) as avg_worth from [Billionaires Statistics Dataset - Billionaires Statistics Dataset] 
group by personName
order by avg(finalWorth)


select * from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---okay so for starters, we may want to group the age column, then we are going to clean the selfmade column into Yes or No, gender column into Male/Female.
---We can also decide to standardize the birthDate column for now. yhh let's do that

select distinct age from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
---so since age starts from 30 and ends at 96, we can say from 30-45 young, 46-60 old and 61 and above very old right. just for this project

select *,
CASE 
WHEN age BETWEEN 29 AND 46 THEN 'Young'
WHEN age > 60 THEN 'Very Old'
ELSE 'Old'
END as Age_bracket From [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

ALTER TABLE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
Add Age_bracket nvarchar(255)

UPDATE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
SET Age_bracket = CASE 
WHEN age BETWEEN 29 AND 46 THEN 'Young'
WHEN age > 60 THEN 'Very Old'
ELSE 'Old'
END

select * from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---Now we want to look at gender column where we want to change the Ms to Males and Fs to Females
select gender,
CASE
WHEN gender = 'M' THEN 'Male'
ELSE 'Female'
END as gender_converted from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

ALTER TABLE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
ADD gender_converted nvarchar(255)

UPDATE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
SET gender_converted = CASE
WHEN gender = 'M' THEN 'Male'
ELSE 'Female'
END

---lets convert selfmade column into yes or no now
SELECT selfMade,
CASE
WHEN selfMade = 0 THEN 'No'
ELSE 'Yes'
END as selfMade_converted from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

ALTER TABLE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
ADD selfMade_converted1 nvarchar(255)

UPDATE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
SET selfMade_converted1 = CASE
WHEN selfMade = 0 THEN 'No'
ELSE 'Yes'
END

---I made a slight mistake with selfMade_converted column and so will drop that column later. kindly take note

SELECT * FROM [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---let's try to standardize the birthDate column for good measure
select birthDate, convert(date, birthDate) as birthDate_converted from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

ALTER TABLE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
ADD birthDate_converted DATE

UPDATE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
SET birthDate_converted = convert(date, birthDate)



---but before let's check for duplicates shall we
select * from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

select *, row_number() over (partition by country, city, finalWorth, birthDate order by personName) row_num from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---okay now lets's create a cte for this to check for duplicates

WITH Billionaires as (
select *, row_number() over (partition by country, city, finalWorth, birthDate order by personName) row_num from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
)
select * from Billionaires where row_num > 1

---okay so we do have one duplicate values so we need to remove right. so yhh
WITH Billionaires as (
select *, row_number() over (partition by country, city, finalWorth, birthDate order by personName) row_num from [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
)
DELETE from Billionaires where row_num > 1

SELECT * FROM [Billionaires Statistics Dataset - Billionaires Statistics Dataset] 


---now we want to drop unused columns

ALTER TABLE [Billionaires Statistics Dataset - Billionaires Statistics Dataset]
drop column
age, selfMade, gender, birthDate, lastName, firstName, birthYear, birthMonth, birthDay, cpi_country, gdp_country, life_expectancy_country, tax_revenue_country_country, total_tax_rate_country,
population_country, selfMade_converted

SELECT * FROM [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---Okay now we can join geograghy
SELECT * FROM [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

---we can create a view based on this 
CREATE VIEW Billionaire as SELECT * FROM [Billionaires Statistics Dataset - Billionaires Statistics Dataset]

select * from Billionaire