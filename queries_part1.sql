delete from CovidDeaths
where date < "2020-01-01" and date > "2022-12-31"

delete from CovidVaccinations
where date < "2020-01-01" and date > "2022-12-31"

-- select distinct location from CovidDeaths
-- where location like "%income%"
-- 
-- DELETE FROM CovidDeaths
-- WHERE location like "%income%"

-- UPDATE CovidDeaths set continent = null where continent = '';
UPDATE CovidDeaths set continent = NULL where continent = '';
UPDATE CovidVaccinations set continent = NULL where continent = '';


SELECT count(continent) from CovidDeaths where continent = null


SELECT count(continent) from CovidVaccinations where continent = ''



select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From CovidDeaths
where location like '%states%'
order by 1,2

-- Total cases vs population => percentage of  the population got Covid
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as PercentagePopulationInfected
From CovidDeaths
where location like '%states%'
order by 1,2

-- countries with highest infection rate compared to population
select location, date, MAX(total_cases) as HighestInfectionCount, total_deaths, MAX(total_deaths/total_cases) * 100 as PercentagePopulationInfected
From CovidDeaths
-- where location like '%states%'
group by location
order by 1,2

-- Countries with the highest death count per population
select location, max(total_deaths) as TotalDeathsCount
From CovidDeaths
-- where location like '%states%'
group by 1
order by 2 desc

SELECT CAST(FORMAT(total_deaths,0)) AS int) as test FROM CovidDeaths;

SELECT FORMAT(total_deaths,0) test FROM CovidDeaths;

select continent from CovidDeaths where location IS NULL;

SELECT * FROM CovidDeaths WHERE location IS NULL;


select location, max(total_deaths) as TotalDeathCount
from CovidDeaths
where continent is not NULL 
group by location 
order by TotalDeathCount

select count(*) from CovidDeaths

-- Countries with the highest death count per population
select continent, max(total_deaths) as TotalDeathsCount
From CovidDeaths
-- where location like '%states%'
group by 1
order by 2 desc

select NULLIF(continent,'') from CovidDeaths


select continent, max(total_deaths) as TotalDeathsCount
From CovidDeaths
-- where location like '%states%'
group by 1
order by 2 desc

-- select NULLIF(continent,'') as EmptyStringNULL from ConvertEmptyStringToNULL;
-- 
-- insert into CovidDeaths(continent) values(NULL);
-- 
-- insert into ConvertEmptyStringToNULL(Name) values('Carol');

-- insert into CovidDeaths(continent)
-- values(IF(continent = '', NULL, '$continent'))


-- ~35min video https://www.youtube.com/watch?v=qfyynHBFOsM
select location, MAX(total_deaths) as TotalDeathsCount
from CovidDeaths 
where continent is not NULL 
group by 1
order by 2 desc

-- breaking down by continents
select continent, MAX(total_deaths) as TotalDeathsCount
from CovidDeaths 
where continent is not NULL 
group by 1
order by 2 desc

-- I changed because I don't have nulls
select continent, MAX(total_deaths) as TotalDeathsCount
from CovidDeaths 
where continent != "" AND continent is not null
group by 1
order by 2 desc

select continent, location, SUM(population) from CovidDeaths
where location != 'World' and continent != ""
group by 2, 1
order by 1 asc,3 desc

-- continents with the highest death in a day 
select continent, MAX(total_deaths) as TotalDeathsCount
from CovidDeaths 
where continent != "" AND continent is not null -- AND location != 'World'
group by 1
order by 2 desc


-- select cast(sum(format(new_deaths,0)) AS UNSIGNED) as TotalDeaths from CovidDeaths ;

select sum(new_deaths)
from CovidDeaths
where continent != "" AND continent is not null -- AND location != 'World'
		AND continent in ("Asia", "Africa", "North America", "South America", "Europe", "Oceania")
		
select min(date) from CovidDeaths



select sum(new_deaths)
from CovidDeaths
where continent is not null -- AND location != 'World' -- continent != "" AND 
		AND continent in ("Asia", "Africa", "North America", "South America", "Europe", "Oceania")
		AND date <= "2021-04-30"
-- 		and location not like '%income'

-- Global numbers
-- select date, 
-- 		SUM(new_cases), 
-- 		cast(sum(format(new_deaths,0)) AS UNSIGNED) as TotalDeaths -- , total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
-- 		-- SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
-- from CovidDeaths
-- where continent != "" AND continent is not null -- AND location != 'World'
-- 		AND ccontinent in ("Asia", "Africa", "North America", "South America", "Europe", "Oceania)
-- group by date
-- order by 1, 2

select location, max(cast(total_deaths as UNSIGNED)) as TotalDeathCount
from CovidDeaths 
where continent is NULL OR continent=""
group by 1
order by 2 desc


-- continent with the highest death count per population
select continent, max(cast(total_deaths as UNSIGNED)) as TotalDeathCount
from CovidDeaths 
where continent is not NULL AND continent != ""
group by 1
order by 2 desc;

-- global numbers
select `date`, 
		(sum(new_cases)) as total_cases,
		(sum(cast(new_deaths as UNSIGNED))) as total_deaths, 
		(sum(cast(new_deaths as UNSIGNED))/sum(new_cases)*100) as DeathPercentage 
from CovidDeaths
where continent is not NULL 
-- 	AND continent != ""
group by 1
order by 1 desc,2

select count(*)
from CovidDeaths 
where continent = ""

select -- `date`, 
		(sum(new_cases)) as total_cases,
		(sum(cast(new_deaths as UNSIGNED))) as total_deaths, 
		(sum(cast(new_deaths as UNSIGNED))/sum(new_cases)*100) as DeathPercentage 
from CovidDeaths
where continent is not NULL 
-- 	AND continent != ""
-- group by 1
order by 1 desc,2

-- Total population vs vaccinations

select dea.continent 
		, dea.location 
		, dea.date 
		, dea.population
		, vac.new_vaccinations
		, SUM(cast(vac.new_vaccinations as UNSIGNED)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		-- OR SUM(CONVERT(vac.new_vaccinations, UNSIGNED)) 
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.`date` = vac.`date`
where dea.continent is not NULL 
and dea.continent in ('Asia', 'Africa', 'North America', 'South America', 'Europe', 'Oceania')
order by 2,3

-- use  CTE 
with PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent 
		, dea.location 
		, dea.date 
		, dea.population
		, vac.new_vaccinations
		, SUM(cast(vac.new_vaccinations as UNSIGNED)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
		-- OR SUM(CONVERT(vac.new_vaccinations, UNSIGNED)) 
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.`date` = vac.`date`
where dea.continent is not NULL 
and dea.continent in ('Asia', 'Africa', 'North America', 'South America', 'Europe', 'Oceania')
-- order by 2,3
)

select *, (RollingPeopleVaccinated/population * 100) as pct_rollingpeoplevaccinated from PopvsVac

-- temp table

drop table if exists PercentPopulationVaccinated

create table PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population int,
new_vaccinations int,
RollingPeopleVaccinated int
)


-- HAS AN ERROR THAT I WAS NOT ABLE TO FIX
-- 	, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
-- 	, SUM(cast(vac.new_vaccinations as UNSIGNED)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--  , SUM(CONVERT(vac.new_vaccinations, FLOAT(2))) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
insert into PercentPopulationVaccinated (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) 
select dea.continent
	, dea.location
	, dea.date
	, dea.population
	, vac.new_vaccinations
	, SUM(CONVERT(vac.new_vaccinations, UNSIGNED)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL -- or dea.continent = '' 
	and dea.continent in ('Asia', 'Africa', 'North America', 'South America', 'Europe', 'Oceania');


select *, (RollingPeopleVaccinated/population * 100) as pct_rollingpeoplevaccinated 
from PercentPopulationVaccinated

select * from PercentPopulationVaccinated


-- create a view to store data for later visualization
create view PercentPopulationVaccinated as 
select dea.continent
	, dea.location
	, dea.date
	, dea.population
	, vac.new_vaccinations
-- 	, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
-- 	, SUM(cast(vac.new_vaccinations as UNSIGNED)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
	, SUM(CONVERT(vac.new_vaccinations, UNSIGNED)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL 
and dea.continent in ('Asia', 'Africa', 'North America', 'South America', 'Europe', 'Oceania');

select * from PercentPopulationVaccinated

select sum(CONVERT(new_vaccinations, UNSIGNED)) from CovidVaccinations;



