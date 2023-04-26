# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT name
  FROM countries
  WHERE gdp > (SELECT MAX(gdp) FROM COUNTRIES WHERE continent = 'Europe');

  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  SELECT
  t1.continent
  , t1.name
  , t1.area
  FROM countries t1
  JOIN (SELECT continent, MAX(area) as area from countries GROUP BY continent) t2
  on t1.continent = t2.continent
  and t1.area = t2.area;
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
  SELECT c.name,c.continent
  FROM countries c
  LEFT JOIN (
      SELECT 
      continent, population as sec_highest_population,
      ROW_NUMBER() OVER (
        PARTITION BY continent
        ORDER BY continent, population desc
      ) row_num
      FROM countries) sub
    ON sub.continent = c.continent
    AND row_num = 2
  WHERE 1=1
  and c.population > 3 * sec_highest_population
  order by population desc;

  SQL
end
