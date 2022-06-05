



SELECT *
FROM [covid-death]
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT location, date, total_cases, total_deaths, population
FROM [covid-death]
WHERE continent IS NOT NULL
ORDER BY 1,2;


---------- Total Cases vs Total Deaths ---------- 
---------- Shows Likelyhood of dying if you contract covid in your country.

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS death_percent , population
FROM [covid-death]
WHERE location LIKE '%states%'
ORDER BY 1,2;

---------- Total cases vs Population ---------- 
---------- Shows what percent of population got Covid

SELECT location, date, population, total_cases, ROUND((total_cases/population)*100,2) AS contraction_percent , population
FROM [covid-death]
WHERE location LIKE '%states%'
ORDER BY 1,2;



---- Countries infection rate vs population

SELECT location, population, MAX(total_cases) AS contraction_count, ROUND((MAX(total_cases)/population)*100,2) AS contraction_percent
FROM [covid-death]
---WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY contraction_percent DESC


---- Countries Death Rate vs Population

SELECT location, population, MAX(cast(total_deaths as int)) AS death_count, ROUND((MAX(total_deaths)/population)*100,2) AS death_percent
FROM [covid-death]
---WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_count DESC


--- Broken down by continent with highest death count

SELECT continent, MAX(cast(total_deaths as int)) AS death_count
FROM [covid-death]
---WHERE location LIKE '%states%'
WHERE continent IS not null
GROUP BY continent
ORDER BY death_count DESC



---- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, ROUND(SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100,2) AS death_percentage
FROM [covid-death]
---WHERE location LIKE '%states%'
WHERE continent IS not null
----GROUP BY date
ORDER BY 1,2


----- Total Population vs Vaccinations

WITH PopvsVac (continent, location, date, population, new_vaccinations, rolling_vaccination)
AS
(
 SELECT [covid-death].continent, [covid-death].location, [covid-death].date, [covid-death].population, [covid-vaccinations].new_vaccinations
 , SUM(convert(bigint,[covid-vaccinations].new_vaccinations)) OVER (PARTITION BY [covid-death].location ORDER BY [covid-death].location, [covid-death].date) AS rolling_vaccination
 FROM [covid-vaccinations]
 JOIN [covid-death]
	ON [covid-vaccinations].location = [covid-death].location
	and [covid-vaccinations].date = [covid-death].date
WHERE [covid-death].continent IS not null
)

SELECT *, (rolling_vaccination/population)*100 as percent_vaccinated
FROM PopvsVac




CREATE VIEW percent_vaccinated AS
 SELECT [covid-death].continent, [covid-death].location, [covid-death].date, [covid-death].population, [covid-vaccinations].new_vaccinations
 , SUM(convert(bigint,[covid-vaccinations].new_vaccinations)) OVER (PARTITION BY [covid-death].location ORDER BY [covid-death].location, [covid-death].date) AS rolling_vaccination
 FROM [covid-vaccinations]
 JOIN [covid-death]
	ON [covid-vaccinations].location = [covid-death].location
	and [covid-vaccinations].date = [covid-death].date
WHERE [covid-death].continent IS not null
