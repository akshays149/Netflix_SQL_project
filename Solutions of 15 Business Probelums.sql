--Netflix Project
--------------------------------------------------------------

--creating netflix database 
create database Netflix

--creating netflix table 
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(max),
	type    VARCHAR(max),
	title	VARCHAR(max),
	director VARCHAR(max),
	casts	VARCHAR(max),
	country	VARCHAR(max),
	date_added	date,
	release_year	INT,
	rating	VARCHAR(255),
	duration	VARCHAR(255),
	listed_in	VARCHAR(255),
	description VARCHAR(max)
);

--imported data directly with wizard 
select * from netflix;
--===============================================================================
--===============================================================================

--Analyzing the dataset of netflix with 15 business probelums 

--1. Count the number of Movies vs TV Shows
select type, count(*) as total_count from netflix
group by type 

--2. Find the most common rating for movies and TV shows
select 
type,rating from
		(select rating, type, count(type) as common_rating, 
		rank() over (partition by type order by count(type)desc ) as max_rate
		from netflix 
		group by rating,type) as t1
where max_rate =1

--3. List all movies released in a specific year (e.g., 2020)
select title, type, release_year  from netflix
where release_year =2020
and type ='movie'

--4. Find the top 5 countries with the most content on Netflix
select top 5 c_rank, count(show_id) as top_shows from
		(select show_id, value as c_rank from netflix
		cross apply   string_split(country,',')) as t2
group by c_rank
order by top_shows desc

--5. Identify the longest movie
with cte as (select title,type, duration, 
			cast(REPLACE(duration,' min',0)as int ) as new_duration from netflix
			where type = 'movie')

select * from cte
where new_duration = (select max(cast(replace(duration,' min',0)as int )) from netflix
					  where type ='movie')

--6. Find content added in the last 5 years
with cte as (select show_id, title, type, 
			 datediff(year,date_added,getdate()) as last_5yrs 
			 from netflix)

select * from cte
where last_5yrs between 0 and 5

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
with cte as (select show_id, type,title,value as indi_directors from netflix
			 cross apply string_split(director,','))

select * from cte 
where indi_directors ='rajiv chilaka'

--second way of doing this 

select * from netflix
where director like'%Rajiv chilaka%'

--8. List all TV shows with more than 5 seasons
 with cte as (select show_id, type,  title, 
			  try_cast(replace(replace(duration,' season',''),'s','')as int) as seasons from netflix
			  where type = 'tv show')

select * from cte
where seasons > 5

--9. Count the number of content items in each genre
select count(show_id) as count_content, value as genre from netflix
cross apply string_split(listed_in,',')
group by value

--10.Find each year and the average numbers of content release in India on netflix, 
-----return top 5 year with highest avg content release!
with content_counts as (select release_year, count(show_id) as total_release from netflix
						cross apply string_split(country, ',')
						where trim(value) = 'india'
						group by release_year)
select top 5 
    release_year, 
    total_release,
    (select avg(cast(total_release as float)) from content_counts) as avg_release
from content_counts
order by total_release desc;

--11. List all movies that are documentaries
select title, type, value as genre from netflix
cross apply string_split(listed_in,',')
where type = 'movie'
and value = 'documentaries'

--another way 

select * from netflix
where listed_in like '%documentaries%'
and type ='movie'

--12. Find all content without a director
select title, type , director from netflix
where director is null

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select count(title) as no_movies , release_year, year(getdate())-release_year from netflix
where cast like '%salman khan%'
and type = 'movie'
group by release_year
having   year(getdate())-release_year <= 10  

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select top 10 count(title) as no_work, type,  country,  value as actors 
from netflix
cross apply string_split(cast,',')
where country like 'india'
and type = 'movie'
group by value,type,country
order by no_work desc

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
------the description field. Label content containing these keywords as 'Bad' and all other 
------content as 'Good'. Count how many items fall into each category.
select count(title), 
	CASE
		when description like '%kill%'		then 'Bad'
		when description like '%violence%'  then 'Bad'
		else 'Good'
		END as categorize
from netflix
group by 	case	when description like '%kill%'		then 'Bad'
		when description like '%violence%'  then 'Bad'
		else 'Good'
		END 
























