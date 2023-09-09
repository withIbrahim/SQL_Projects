CREATE DATABASE Protfolio_Project



select * from CovidDeaths
order by 3,4


--select * from CovidVaccinations
--order by 3,4


SELECT
	Location,date,new_cases,total_cases,total_deaths,population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 
	Location,date


--Looking at Total Case vs Total Deaths


SELECT
	Location,date,new_cases,total_cases,total_deaths,
	(total_deaths/total_cases)*100 as Percentage
FROM CovidDeaths
WHERE Location = 'India' 
	AND continent IS NOT NULL
ORDER BY 
	Location,date


--- Looking Total Infactions VS Population
-- Shows what percentage of population infected with Covid


SELECT
	Location,date,total_cases, population,
	round(((total_cases/population)*100),3) as Percentage
FROM CovidDeaths
WHERE Location = 'India' 
	AND continent IS NOT NULL
ORDER BY 
	Location,date


	
SELECT
	Location,date,total_cases, population,
	round(((total_cases/population)*100),3) as PercentPopulationInfected
FROM CovidDeaths
WHERE --Location = 'India' AND 
	 continent IS NOT NULL
ORDER BY 
	1,2


--SELECT
--	Location,date,new_cases,total_cases,
--	round(((new_cases/total_cases)*100),3) as Percentage
--FROM CovidDeaths
--WHERE Location = 'India' AND 
--     continent IS NOT NULL
--ORDER BY 
--	Percentage DESC


---- Countries with Highest Infection Rate compared to Population


	SELECT
		Location,population,MAX(total_cases) as Total_Case, 
		round(MAX(((total_cases/population)*100)),3) as PercentPopulationInfected
	FROM CovidDeaths
	WHERE --Location = 'India' AND 
		 continent IS NOT NULL
	GROUP BY 
		Location,population
	ORDER BY 
		PercentPopulationInfected DESC


/*
-- Countries with Highest Death Count per Population
*/


	SELECT
		Location,population,MAX(cast(total_deaths as int)) as Highest_Deaths
	FROM CovidDeaths
	WHERE --Location = 'India' AND 
		 continent IS NOT NULL
	GROUP BY 
		Location,population
	ORDER BY 
		Highest_Deaths DESC


/*
-- Showing contintents with the highest death count per population
*/


	SELECT
		location,MAX(cast(total_deaths as int)) as Highest_Deaths
	FROM CovidDeaths
	WHERE 
		continent IS NOT NULL
	GROUP BY 
		location
	ORDER BY 
		Highest_Deaths DESC


--Total Cases and Total Deaths over the GOLOBAL ---


SELECT
	SUM(new_cases) as Total_Cases,
	SUM(cast(new_deaths as int)) as Total_Deaths,
	ROUND(SUM(cast(new_deaths as int)) / SUM(new_cases)*100,2) as Death_Percentage
FROM CovidDeaths
WHERE continent IS NOT NULL



/*
Total Vacctinations VS Total Population
*/

SELECT
	d.continent, 
	d.location,
	d.date,
	d.population, 
	v.new_vaccinations
FROM CovidDeaths d JOIN CovidVaccinations v
	ON d.location = v.location
	AND d.date = v.date
WHERE D.continent IS NOT NULL
ORDER BY 
	location

--Highest Vacctinatons got each country
	

	SELECT 
		d.location,
		d.population, 
		sum(CAST(v.new_vaccinations AS int)) as Total_Vacctinations,
		ROUND(CAST(v.new_vaccinations AS int) / d.population)*100,2) as Vacctination_Percentage
	FROM CovidDeaths d JOIN CovidVaccinations v
		ON d.location = v.location
		AND d.date = v.date
	WHERE D.continent IS NOT NULL
	GROUP BY 
		d.location,d.population
	ORDER BY 
		Total_Vacctinations DESC


--


Select 
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 
	2,3



---Using CTE to calculate the percentage of vacctinatons

WITH vac_prcntg AS (
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
	From CovidDeaths dea
	Join CovidVaccinations vac
		On dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null 

	)

SELECT *, (RollingPeopleVaccinated / population)*100
FROM vac_prcntg


 

-- Using Temp Table to perform Calculation for Percentage of Vacctination 


Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
		   Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
		   SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
From CovidDeaths d Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date


Select * From PercentPopulationVaccinated



--Create View for furter analysis in Power BI --

Create view View_PercentPopulationVaccinated as 
	Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
		   SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
	From CovidDeaths d Join CovidVaccinations v
		On d.location = v.location
		and d.date = v.date
	Where d.continent is not null 

select * from View_PercentPopulationVaccinated
