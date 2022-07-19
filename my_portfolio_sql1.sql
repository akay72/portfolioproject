select * from myportfolio..CovidDeaths
where continent is not null

select location,date,total_cases,new_cases,total_deaths,population
from myportfolio..CovidDeaths
where continent is not null
order by 1,2

--total cases vs total death

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from myportfolio..CovidDeaths
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from myportfolio..CovidDeaths
order by death_percentage desc

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from myportfolio..CovidDeaths
where location like 'india'
order by 1,2

--total cases vs population
--show what percentage of populTION GOT Covid

select location,date,total_cases,population,(total_cases/population)*100 as cases_percentage
from myportfolio..CovidDeaths
where location like 'india'
order by 1,2

select location,date,total_cases,population,(total_cases/population)*100 as percentpopulationinfected
from myportfolio..CovidDeaths
where location like '%states%'
order by 1,2

select location,date,total_cases,population,(total_cases/population)*100 as percentpopulationinfected
from myportfolio..CovidDeaths
order by 1,2

--lookin at country with highest infection rate compared to population

select location,population,MAX(total_cases) as highestinfectedcount ,MAX((total_cases/population))*100 as percentpopulationinfected
from myportfolio..CovidDeaths
group by population,location
order by percentpopulationinfected desc

 
select location,population,MAX(total_cases) as highestinfectedcount ,MAX((total_cases/population))*100 as percentpopulationinfected
from myportfolio..CovidDeaths
group by population,location
order by percentpopulationinfected desc
  
select total_cases
from myportfolio..CovidDeaths
 where location like 'india'


--total death case per population
select location , MAX(total_deaths) as total_death_count
from myportfolio..CovidDeaths
group by location
order by total_death_count desc


select location , MAx(cast(total_deaths as int )) as total_death_count
from myportfolio..CovidDeaths
where continent is not null
group by location
order by total_death_count desc

--lets break down by continet

select location , MAx(cast(total_deaths as int )) as total_death_count
from myportfolio..CovidDeaths
where continent is null
group by location
order by total_death_count desc


--lets break down by date

select date,sum(new_cases)as new_cases,sum(cast(new_deaths as int))as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from myportfolio..CovidDeaths
where continent is not null
group by date
order by 1


select sum(new_cases)as new_cases,sum(cast(new_deaths as int))as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from myportfolio..CovidDeaths
where continent is not null
--group by date
order by 1

--looking for total population vs vaccination

select * from
myportfolio..CovidVaccinations as vac
join myportfolio..CovidDeaths as dea
on vac.location=dea.location
and vac.date=dea.date

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from
myportfolio..CovidVaccinations as vac
join myportfolio..CovidDeaths as dea
on vac.location=dea.location
and vac.date=dea.date
where dea.continent is not null
order by 4,5

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int)) over (partition by dea.location
order by dea.location, dea.date) as rollincount
--,(rollincount/dea.population)*100
from
myportfolio..CovidVaccinations as vac
join myportfolio..CovidDeaths as dea
on vac.location=dea.location
and vac.date=dea.date
where dea.continent is not null
order by 2,3


drop table if exists #percentpopulationvaccinated1
create table #percentpopulationvaccinated1
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollincount numeric)

insert into #percentpopulationvaccinated1

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int)) over (partition by dea.location
order by dea.location, dea.date) as rollincount
--,(rollincount/dea.population)*100
from
myportfolio..CovidVaccinations as vac
join myportfolio..CovidDeaths as dea
on vac.location=dea.location
and vac.date=dea.date
--where dea.continent is not null
--order by 2,3

select * , (rollincount/population)*100
from #percentpopulationvaccinated1



create view percentpopulationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int)) over (partition by dea.location
order by dea.location, dea.date) as rollincount
--,(rollincount/dea.population)*100
from
myportfolio..CovidVaccinations as vac
join myportfolio..CovidDeaths as dea
on vac.location=dea.location
and vac.date=dea.date
where dea.continent is not null
--order by 2,3

select * from percentpopulationvaccinated