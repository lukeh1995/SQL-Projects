USE [Luke Test DB]

select Location, date, total_cases, total_deaths, population
FROM CovidDeaths$
order by 1,2;

--Value 'PCN' in total_cases column, remove.
DELETE FROM CovidDeaths$
WHERE [total_cases] LIKE 'PCN';

--total_cases is incorrect column type, change accordingly to INT
ALTER TABLE CovidDeaths$
ALTER COLUMN total_cases DECIMAL;

--Explore total cases vs. total deaths, add new column for death rate
select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopInfected
FROM CovidDeaths$
GROUP BY Location, Population
order by PercentPopInfected desc;


--Showing Countries with highest death count per population
select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths$
WHERE continent is not null
GROUP BY Location
order by TotalDeathCount desc;

--Exploring Continents with the highest death count per population

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths$
WHERE continent is not null
GROUP BY continent
order by TotalDeathCount desc;


--Exploring global numbers
--Requires aggregate function
SELECT date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage --total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths$
WHERE continent is not null
group by date
order by 1,2;

--Join two tables together
select dea.continent, dea.location, dea.population, tes.new_vaccinations, SUM(CONVERT(int,tes.new_vaccinations)) OVER (partition by dea.location Order by dea.location, dea.date)
FROM CovidDeaths$ dea
JOIN CovidTests$ tes
ON dea.location = tes.location
and dea.date = tes.date
where dea.continent is not null
ORDER BY 2,3;
