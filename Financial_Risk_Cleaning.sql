-- Cleaning and exploring a financial risk dataset using MySQL.

select * from netf.financial_risk;

use netf;

create table risk like financial_risk;

insert into risk select * from financial_risk;

Select*
from risk;

select COUNT(*)
from risk;

-- DATA CLEANING

-- Handling Missing Values

select * from risk where Income is null;

select* from risk where Income is null or Income = '';

-- chheck the average of Income column

select avg(Income) from risk as AverageIncome
where Income is not null or income = '';

-- Impute The Null or blank with Average Income

Update risk, (select avg(Income) as AvgIncome 
from risk where Income is not null or Income = '') as risk1
set risk.Income = risk1.AvgIncome
where risk.Income is null or risk.Income = '';

update risk 
set Income = round(Income, 2);

-- Standardizing Data

select City 
from risk;

update risk 
set City = upper(City);

select Gender
from risk;

update risk 
set Gender = 'Male'
where Gender = 'M';

Update risk 
set Gender = 'Female'
where Gender = 'F';

-- Check for Duplicates

select Age, `Marital Status`, `Credit Score`, `Debt-to-Income Ratio`, City, COUNT(*)
from risk
group by Age, `Marital Status`, `Credit Score`, `Debt-to-Income Ratio`, City
having COUNT(*) > 1;

-- Exploratory Data Analysis

-- Descriptive Statistics

select
	avg(Income) as Average_Income,
	STD(Income) as Std_Income,
	min(Income) as Min_Income,
	max(Income) as Max_Income
from risk;

select
	avg(Age) as Average_Age,
	min(Age) as Min_Age,
	max(Age) as Max_Age
from risk;

--  Distribution Analysis

select
    case
        when Income < 20000 then 'Below 20k'
        when Income between 20000 and 50000 then '20k-50k'
        else 'Above 50k'
    end as Income_Bracket,
    COUNT(*) as Count
from risk
group by Income_Bracket;

select Gender, COUNT(*) as Count
from risk
group by Gender;

-- Risk Analysis

select
    `Loan Purpose`,
    avg(
        case `Risk Rating`
            when 'Low' then 1
            when 'Medium' then 2
            when 'High' then 3
            else null
        end
    ) as Avg_Risk_Rating
from risk
group by `Loan Purpose`;

select 
	`Marital Status`,
	avg(
		case `Risk Rating`
			when 'Low' then 1
            when 'Medium' then 2
            when 'High' then 3
            else null
		end
        ) as av_Risk_Rating
from risk
group by `Marital Status`;

select 
	`Years at Current Job`,
	avg(
		case `Risk Rating`
			when 'Low' then 1
            when 'Medium' then 2
            when 'High' then 3
            else null
		end
        ) as av_Risk_Rating
from risk
group by `Years at Current Job`;

select
    case
        when Age < 25 then 'Under 25'
        when Age between 25 and 34 then '25-34'
        when Age between 35 and 44 then '35-44'
        when Age between 45 and 54 then '45-54'
        when Age between 55 and 64 then '55-64'
        else '65+'
    end as Age_Group,
    avg(`Assets Value`) as Avg_Assets_Value
from risk
group by Age_Group
order by Age_Group;

select
    case
        when `Credit Score` < 600 then 'Poor'
        when `Credit Score` between 600 and 700 then 'Average'
        else 'Good'
    end as Credit_Score_Category,
    COUNT(*) as Count
from risk
group by Credit_Score_Category;

-- Trends Over Time

select `Years at Current Job`, avg(Income) as Avg_Income
from risk
group by `Years at Current Job`;

select
    `Years at Current Job`,
    avg(`Loan Amount`) as Avg_Loan_Amount
from risk
group by `Years at Current Job`
order by `Years at Current Job`;

select 
    case
        when Age < 25 then 'Under 25'
        when Age between 25 and 34 then '25-34'
        when Age between 35 and 44 then '35-44'
        when Age between 45 and 54 then '45-54'
        when Age between 55 and 64 then '55-64'
        else '65+'
    end as Age_Group,
    avg(`Credit Score`) as Avg_Credit_Score
from risk
group by Age_Group
order by Age_Group;

