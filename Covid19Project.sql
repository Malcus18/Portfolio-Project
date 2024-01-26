select*
from CovidDeaths
Order by 3,4

----select*
----from Covidvaccination
----order by 3,4

--SELECT location,date, total_cases, new_cases, total_deaths, population
--FROM CovidDeaths

--SELECT location,date, total_cases,total_deaths, (total_deaths/total_cases) *100 AS PercetageDeath
--FROM CovidDeaths
--WHERE location like '%uganda%'
--Order by 1,2

----looking at total cases vs population
--%population that got covid
SELECT location,date,population, total_cases, (total_cases/population) *100 AS PercetagePopulation
FROM CovidDeaths
--WHERE location like '%uganda%'
Order by 1,2

--Looking at countries with the highest infection rate to population
SELECT location,population, MAX(total_cases) AS HighestInfectioncount, Max((total_cases/population)) *100 AS PercetagePopulation
FROM CovidDeaths
--WHERE location like '%uganda%'
Group by location,population
Order by PercetagePopulation desc

--Country with the highest death count to population
SELECT location, MAX(Cast(total_deaths as int)) AS HighestDeathCounts 
FROM CovidDeaths
--WHERE location like '%uganda%'
Where continent is not null
Group by location
Order by HighestDeathCounts  desc

--LETS BREAK THINGS BY CONTINENT
SELECT location, MAX(Cast(total_deaths as int)) AS HighestDeathCounts 
FROM CovidDeaths
--WHERE location like '%uganda%'
Where continent is null
Group by location
Order by HighestDeathCounts  desc

--Showing the continent with the highest death count

SELECT Continent, MAX(Cast(total_deaths as int)) AS HighestDeathCounts 
FROM CovidDeaths
--WHERE location like '%uganda%'
Where continent is not null
Group by Continent
Order by HighestDeathCounts  desc

--GLOBAL NUMBERS
SELECT date, SUM(new_cases)as HighestDeathCounts, sum(cast(new_deaths as int))as HighestDeathCounts
From CovidDeaths
Where continent is not null
Group by date
order by 1,2

--GLOBAL % Rate
SELECT  SUM(new_cases)as HighNewCounts, sum(cast(new_deaths as int))as HighestDeathCount, sum(cast(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
From CovidDeaths
Where continent is not null
--Group by date
order by 1,2elect

--Joining the two tables
SELECT *
FROM CovidDeaths dea
JOIN Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
Order by 1,2

--Looking at the total population vs vaccination rate
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM CovidDeaths dea
JOIN Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
Order by 1,2

--Looking at the total population vs some of new vaccination rate

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition By dea.location order by dea.location, dea.date) as TotalVaccinatedpeople
FROM CovidDeaths dea
JOIN Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
Order by 1,2


--USE CTE POPULATION VS VACCINATION
With popvsvac(continent,location,date,population,new_vaccinations,TotalVaccinatedpeople)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition By dea.location order by dea.location, dea.date) as TotalVaccinatedpeople
FROM CovidDeaths dea
JOIN Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--Order by 1,2
)

SELECT *, (TotalVaccinatedpeople/population)*100 as percet
FROM Popvsvac

--CREATE VIEW TO STORE DATA FOR LATER VISUALIZATIONS
Create view percentagevaccinatedpeople AS 
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition By dea.location order by dea.location, dea.date) as TotalVaccinatedpeople
FROM CovidDeaths dea
JOIN Covidvaccination vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--Order by 1,2




































