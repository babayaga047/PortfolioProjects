SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations
--ORDER BY 3,4

--Select data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

--Changing string datatypes of columns to float after getting division error
ALTER TABLE CovidDeaths
ALTER COLUMN total_cases float;

ALTER TABLE CovidDeaths
ALTER COLUMN total_deaths float;

--Looking at total cases vs total deaths
--Shows the likelihood of dying if you contract covid 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'DeathPercentage'
FROM CovidDeaths
WHERE location like '%india%'
ORDER BY 1,2

--Looking at total cases vs population
--Shows what percentage of population got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as 'InfectedPopulationPercentage'
FROM CovidDeaths
WHERE location like '%india%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to poulation
SELECT location,  population, MAX(total_cases) as 'HighestInfectionCount', MAX((total_cases/population))*100 as 'MaxInfectedPopulationPercentage'
FROM CovidDeaths
--WHERE location like '%india%'
GROUP BY location, population
ORDER BY MaxInfectedPopulationPercentage desc

--Countries with max deaths
SELECT location,  population, SUM(total_deaths) as 'TotalDeathCount'
FROM CovidDeaths
--WHERE location like '%india%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY TotalDeathCount desc

--Breaking down things on the basis of continents
SELECT continent, SUM(total_deaths) as 'TotalDeathCount'
FROM CovidDeaths
--WHERE location like '%india%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc

SELECT continent, SUM(new_cases) as 'TotalNewCases', SUM(new_deaths) as 'TotalNewDeaths', SUM(new_deaths)/SUM(new_cases) as 'NewDeathPercentage'
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 'NewDeathPercentage' desc

--Joining both tables
SELECT*
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS bigint)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as 'CumulativePeopleVaccinated'
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3

--Using CTE
WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, CumulativePeopleVaccinated)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS bigint)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) as 'CumulativePeopleVaccinated'
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT*, (CumulativePeopleVaccinated/Population)*100
FROM PopVsVac



-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
CumulativePeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as CumulativePeopleVaccinated
--, (CumulativePeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (CumulativePeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as CumulativePeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
