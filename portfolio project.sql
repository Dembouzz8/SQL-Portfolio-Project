
select * from PortfolioProject..CovidDeaths
order by 3,4


--select * from PortfolioProject..CovidVaccination
--order by 3,4


select location, date, total_cases, new_cases, total_deaths,population 
from PortfolioProject..CovidDeaths
order by 1,2

--looking at total_cases vs total_deaths
select location, date, total_cases, new_cases, total_deaths, (total_deaths/ total_cases) *100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%africa%'
order by 1,2

--looking at total cases vs population
select location, date, population, total_cases, (total_cases/ population) *100 as CasePercentage
from PortfolioProject..CovidDeaths
where location like '%africa%'
order by 1,2

--looking at countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/ population)) *100 as CasePercentage
from PortfolioProject..CovidDeaths
--where location like '%africa%'
group by location,population
order by  CasePercentage desc

--showing countries with high death rate
 select continent, max(cast(total_deaths as int)) as HighestDeathCount 
 from PortfolioProject..CovidDeaths
 where continent is not null
 group by continent
 order by HighestDeathCount desc
 
 --showing continent with highest death rate per population
  select continent,population, max(cast(total_deaths as int)) as HighestDeathCount 
 from PortfolioProject..CovidDeaths
 where continent is not null
 group by continent, population
 order by HighestDeathCount desc

 --looking at total population vs vaccinations
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinated
 from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 --Using CTE
  WITH PopvsVac (continent,location, date, population,new_vaccinations, RollingVaccinated)
  as
  (
   select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinated
 from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
  )
  select *, (RollingVaccinated/population)*100 
  from PopvsVac