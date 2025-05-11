--drop TABLE if exists netflix;
create TABLE netflix(
	show_id varchar(7),
	type varchar(10),
	title varchar(105),
	director varchar(210),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250)
)

select * from netflix

-- Check if import was properly done 
SELECT
	count(*)
from netflix

-- 1) Count Number of Movies vs TV Shows
select 
	type,
	count(*) as total_count
from netflix
group by 1

-- 2) Find the Most Common Rating for Movies and TV Shows
WITH rating_table as	
	(SELECT
		type,
		rating,
		count(rating) as rating_count
	from netflix
	group by 1,2
	),
ranked_table as(
	select
		type,
		rating,
		rating_count,
		rank() over(partition by type order by rating_count desc) as rank
from rating_table)
select 
	type,
	rating as most_common_rating
from ranked_table
where rank = 1

-- 3) List All Movies Released in a Specific Year (e.g., 2020)
SELECT
	release_year,
	title
from netflix
where type = 'Movie' and release_year = 2020

-- 4) Find the Top 5 Countries with the Most Content on Netflix
select
	unnest(string_to_array(country,',')) as new_country,
	count(show_id) as content_amount
from netflix
group by 1
order by 2 desc
limit 5

-- 5) Identify the Longest Movie
select 
	title,
	duration
from netflix
where type = 'Movie' and duration = (select max(duration) from netflix)

-- 6) Find Content Added in the Last 5 Years
select
	extract(year from (to_date(date_added,'Month DD, YYYY'))) as year_added,
	title
from netflix
where to_date(date_added,'Month DD, YYYY') >= current_date - interval '5 years'
group by 1,2
order by 1 desc

-- 7) Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select 
	*
from netflix
where director ilike '%Rajiv Chilaka%'

-- 8) List All TV Shows with More Than 5 Seasons
select 
	title,
	Cast (Split_Part(duration,' ',1)as integer)  as season_duration
from netflix
where 
	type = 'TV Show' and Cast (Split_Part(duration,' ',1)as integer) >5
group by 1,2
order by 2 desc

-- 9) Count the Number of Content Items in Each Genre
select 
	unnest(string_To_Array(listed_in,',')) as genre,
	count(show_id) as title_count
from netflix
group by 1
order by 2 desc

-- 10) Find each year and the average numbers of content release in India on netflix
select
	release_year,
	round(avg(content_count),0) as conten_count_avg
from 
(
	select 
		release_year,
		count(*) as content_count
	from netflix
	where country ilike '%India%'
	group by 1
) as t1
group by 1
order by 2 desc
limit 5

-- 11) List All Movies that are Documentaries
select
	*
from netflix
where 
	type = 'Movie' and listed_in ilike '%Documentaries%'

-- 12) Find All Content Without a Director
select 
	*
from netflix
where director is null

-- 13) Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
select
	release_year,
	count(show_id) as Movie_count
from netflix
where 
	casts ilike '%Salman Khan%' and release_year > extract(year from current_date) - 10
group by 1

-- 14) Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
select
	unnest(string_to_array(casts,',')) as actor,
	count(*) as Movie_count
from netflix
where 
	country ilike '%India%'
group by 1
order by 2 desc
limit 10

-- 15) Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
select 
	category,
	count(category) as category_count
from
	(select 
		*,
		case when description ilike '%kill%' or 
				  description ilike '%Violence%' then 'Bad'
			ELSE 'Good'
			end as category
	from netflix)as t1
group by 1