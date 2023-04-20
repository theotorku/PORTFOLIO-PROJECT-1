

select total_cases, total_deaths
from covid_death
order by 1 


select *
from [dbo].[covid_death]
order by 3,4


--select * 
--from [dbo].[covid_vaccination]
--order by 3,4

--selecting Required Data

select Location, date, total_cases, new_cases, total_deaths, population
from [dbo].[covid_death]
order by 1,2


--Looking at Total cases vs Total Deaths
--Shows likelihood of dying if you contract civid in your country

(***
select Location, date, total_cases, total_deaths, (convert(int,[total_cases])/[total_deaths])*100 as DeathPercentage
from [dbo].[covid_death]
order by 1,2 
(****
select Location, date, total_cases, total_deaths, (cast([total_cases] as int)/[total_deaths])*100 as DeathPercentage
from [dbo].[covid_death]
order by 1,2  

***) seek help

select Location, date, total_cases, total_deaths, (convert(int,[total_cases])/[total_deaths])*100 as DeathPercentage
from [dbo].[covid_death]
order by 1,2 


-->>>>Total Cases Vs Population ( United States )
--shows what percentage of population got covid


select Location, date, total_cases, total_deaths, (total_cases/population)*100 as DeathPercentage
from [dbo].[covid_death]
order by 1,2


select Location, date, total_cases, total_deaths, (convert(int, [total_cases])/[total_deaths])*100  as DeathPercentage
from [Portfolio Project]..covid_death
where location like '%states%'
order by Location, date


select Location, date, total_cases, total_deaths
from [Portfolio Project]..covid_death
order by total_deaths desc


-->>>>>> Looking at Countries with highest Infection rate compared to Population

select [location], [population], MAX(total_cases) as HigestInfection, MAX((total_cases/population))*100 as PercentPopulationInfected
from [dbo].[covid_death]
--where location like '%states%'
group by Location, Population
--order by 1,2
order by PercentPopulationInfected desc



select [location], [population], MAX(total_cases) as HigestInfection, [total_deaths],
      MAX((total_cases/population))*100 as PercentPopulationInfected
from [dbo].[covid_death]
--where location like '%states%'
group by Location, Population, [total_deaths]
--order by 1,2
order by HigestInfection desc


-->>>>>Showing Counries with Highest Death Count per Population



select [location], MAX(Total_deaths) as TotalDeathCount
from [dbo].[covid_death]
--where location like '%states%'
where continent is not null
group by Location
order by TotalDeathCount desc


--BREAKING THINGS DOWN BY CONTINENT

select [continent], MAX(Total_deaths) as TotalDeathCount
from [dbo].[covid_death]
--where location like '%states%'
--where continent is not null
group BY [continent]
order by TotalDeathCount desc


-->>>SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

select [continent], MAX(Total_deaths) as TotalDeathCount
from [dbo].[covid_death]
--where location like '%states%'
where continent is not null
group BY [continent]
order by TotalDeathCount desc



-->>>GLOBAL NUMBERS


(****
select date, sum(convert(new_cases as int)) as total_cases, SUM(convert(new_deaths as int)) as total_deaths, sum(convert(new_death as int))/sum(New_Cases)*100 as DeathPercentage
from [Portfolio Project]..covid_death
--where location like '%states%'
--where continent in not null
GROUP BY total_cases, total_deaths, DeathPercentage
order by 1,2
****)



select [location], [population], MAX(total_cases) as HigestInfection, [total_deaths], MAX((total_cases/population))*100 as PercentPopulationInfected
from [dbo].[covid_death]
--where location like '%states%'
group by Location, Population, [total_deaths]
--order by 1,2
order by total_deaths desc


-->>>>> USE CTE <<<<<--

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
count(vac.new_vaccinations)  over (partition by dea.location)  countnew_vac
from covid_death as dea
join covid_vaccination as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)

SELECT *, (RollingPeopleVaccinated) * 100 
FROM PopvsVac


------>>>>>>TEMP_TABLE

CREATe TABLE PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccination numeric
)

Insert into PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
count(vac.new_vaccinations)  over (partition by dea.location)  countnew_vac
from covid_death as dea
join covid_vaccination as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


select continent, (cast(RollingPeopleVaccination as int)) RollingPeopleVaccination
from PercentPopulationVaccinated
--group by continent, RollingPeopleVaccination
where continent = 'Europe'

select continent, (cast(RollingPeopleVaccination as int)) RollingPeopleVaccination
from PercentPopulationVaccinated
--group by continent, RollingPeopleVaccination
where continent = 'North America'

select continent, (cast(RollingPeopleVaccination as int)) RollingPeopleVaccination
from PercentPopulationVaccinated
--group by continent, RollingPeopleVaccination
where continent = 'Africa'





select *
from [dbo].[PercentPopulationVaccinated]
-->>>>>CREATING VIEWS FOR VISUALIZATIONS

--VIEW 1

CREATE VIEW TOTALDEATHCOUNT AS
select [continent], MAX(Total_deaths) as TotalDeathCount
from [dbo].[covid_death]
--where location like '%states%'
--where continent is not null
group BY [continent]
--order by TotalDeathCount desc

SELECT *
FROM TOTALDEATHCOUNT

--VIEW 2

CREATE VIEW CONTINENTALDEATHCOUNT AS
select [continent], MAX(Total_deaths) as TotalDeathCount
from [dbo].[covid_death]
--where location like '%states%'
where continent is not null
group BY [continent]
--order by TotalDeathCount desc

SELECT * FROM [dbo].[CONTINENTALDEATHCOUNT]

SELECT * FROM [dbo].[TOTALDEATHCOUNT]


CREATE VIEW PERCENTPOPULATIONINFECTED AS
select [location], [population], MAX(total_cases) as HigestInfection, [total_deaths], MAX((total_cases/population))*100 as PercentPopulationInfected
from [dbo].[covid_death]
--where location like '%states%'
group by Location, Population, [total_deaths]
--order by 1,2
--order by total_deaths desc

SELECT * FROM [dbo].[PERCENTPOPULATIONINFECTED]


-->>>>>>VIEW 3 <<<<<--

CREATE VIEW COUNT_NEW_VAC AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
count(vac.new_vaccinations)  over (partition by dea.location)  countnew_vac
from covid_death as dea
join covid_vaccination as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3



-->>>>>>VIEW 4 <<<<<--

CREATE VIEW DeathPercentage AS
select Location, date, total_cases, total_deaths, (total_cases/population)*100 as DeathPercentage
from [dbo].[covid_death]
--order by 1,2

SELECT * 
FROM [dbo].[DeathPercentage]

-->>>>>>VIEW 4 <<<<<--
CREATE VIEW COUNTRYDEATHCOUNT AS
select [location], MAX(Total_deaths) as TotalDeathCount
from [dbo].[covid_death]
--where location like '%states%'
where continent is not null
group by Location
--order by TotalDeathCount desc

SELECT *
FROM [dbo].[COUNTRYDEATHCOUNT]


-->>>>>>VIEW 4 <<<<<--
CREATE VIEW US_DEATHCOUNT AS
select Location, date, total_cases, total_deaths, (convert(int, [total_cases])/[total_deaths])*100  as DeathPercentage
from [Portfolio Project]..covid_death
where location like '%states%'
--order by Location, date

SELECT *
FROM US_DEATHCOUNT

CREATE VIEW Europe_DEATHCOUNT AS
select continent, (cast(RollingPeopleVaccination as int)) RollingPeopleVaccination
from PercentPopulationVaccinated
--group by continent, RollingPeopleVaccination
where continent = 'Europe'


CREATE VIEW NORTHAMERICA_DEATHCOUNT AS
select continent, (cast(RollingPeopleVaccination as int)) RollingPeopleVaccination
from PercentPopulationVaccinated
--group by continent, RollingPeopleVaccination
where continent = 'North America'


CREATE VIEW Africa_DEATHCOUNT AS
select continent, (cast(RollingPeopleVaccination as int)) RollingPeopleVaccination
from PercentPopulationVaccinated
--group by continent, RollingPeopleVaccination
where continent = 'Africa'
