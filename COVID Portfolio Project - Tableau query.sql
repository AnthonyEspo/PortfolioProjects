---/ Data obtained via  https://ourworldindata.org/covid-deaths

-- 1. Global Rates

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [covid-death]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


---2. Death Per Continent

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [covid-death]
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income' )
Group by location
order by TotalDeathCount desc


-- 3. Infection Percent Per Country

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [covid-death]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4. Percent Population Infected


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [covid-death]
Where date <= '2022-05-31'
Group by Location, Population, date
order by PercentPopulationInfected desc
