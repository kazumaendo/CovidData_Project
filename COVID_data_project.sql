SELECT *
FROM covid_data.CovidDeaths cd
where continent is not null and continent <> '' 
order by 3,4

/*SELECT *
FROM covid_data.CovidVaccinations cv 
order by 3,4*/

SELECT location, date, total_cases, new_cases, total_deaths, population
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 
order by location, date

/*looking at total cases vs total deaths*/
SELECT location, date, total_cases,total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
from covid_data.CovidDeaths cd 
where location = 'Japan' 
order by location, date

/*looking at total cases vs population*/
SELECT location, date, total_cases,population, (total_cases /population)*100 as PercentPopulationInfected
from covid_data.CovidDeaths cd 
where location = 'Japan'
order by location, date

/*looking at countries with highest infection rate compared to population*/
SELECT location, MAX(total_cases) as HighestInfectionCount,population, MAX((total_cases/population))*100 as PercentPopulationInfected
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 
group by location,population
order by PercentPopulationInfected DESC 

/*looking at countries with highest death rate compared to population*/
SELECT location, MAX(total_deaths) as HighestInfectionCount,population, MAX((total_deaths /population))*100 as PercentPopulationDeath
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 
group by location,population
order by PercentPopulationDeath DESC 

/*looking at countries with highest infection count*/
SELECT location, MAX(total_cases) as TotalInfectionCount
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 
group by location
order by TotalInfectionCount DESC

/*looking at countries with highest death count*/
SELECT location, MAX(total_deaths) as TotalDeathCount
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 
group by location
order by TotalDeathCount DESC 

/*looking at continents with highest infection count*/
SELECT continent, MAX(total_cases) as TotalInfectionCount
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 
group by continent
order by TotalInfectionCount DESC


/*looking at continents with highest death count*/
SELECT continent, MAX(total_deaths) as TotalDeathCount
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 
group by continent
order by TotalDeathCount DESC 

/*looking at GLOBAL NUMBERS*/
SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage  
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 	
group by date
order by date, total_cases 	

/*total death percentage across the world*/
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage  
from covid_data.CovidDeaths cd 
where continent is not null and continent <> '' 	
order by date, total_cases 	

/*total population vs vaccination*/
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cv.new_vaccinations) over (PARTITION by cd.location ORDER BY cd.location, cd.date) as rolling_vaccinations 
FROM covid_data.CovidDeaths cd 
join covid_data.CovidVaccinations cv 
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null and cd.continent <> '' and cd.location = 'Japan'	
order by location, cd.date

/*create temp table*/
drop table if exists PercentPopulationVaccinated
create table PercentPopulationVaccinated
(
continent varchar(255),
location varchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_vaccinations numeric
)

insert ignore into PercentPopulationVaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cv.new_vaccinations) over (PARTITION by cd.location ORDER BY cd.location, cd.date) as rolling_vaccinations 
FROM covid_data.CovidDeaths cd 
join covid_data.CovidVaccinations cv 
on cd.location = cv.location and cd.date = cv.date

Select *, (rolling_vaccinations/population)*100 as PercentPopulationVaccinated
from PercentPopulationVaccinated

/*creating view for visualization*/
create view PercentPopulationVaccinatedView as
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(cv.new_vaccinations) over (PARTITION by cd.location ORDER BY cd.location, cd.date) as rolling_vaccinations 
FROM covid_data.CovidDeaths cd 
join covid_data.CovidVaccinations cv 
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null and cd.continent <> '' 	













