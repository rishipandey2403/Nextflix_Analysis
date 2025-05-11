# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.


## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select 
	type,
	count(*) as total_count
from netflix
group by 1
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT
	release_year,
	title
from netflix
where type = 'Movie' and release_year = 2020
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select
	unnest(string_to_array(country,',')) as new_country,
	count(show_id) as content_amount
from netflix
group by 1
order by 2 desc
limit 5
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select 
	title,
	duration
from netflix
where type = 'Movie' and duration = (select max(duration) from netflix)
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select
	extract(year from (to_date(date_added,'Month DD, YYYY'))) as year_added,
	title
from netflix
where to_date(date_added,'Month DD, YYYY') >= current_date - interval '5 years'
group by 1,2
order by 1 desc
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select 
	*
from netflix
where director ilike '%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select 
	title,
	Cast (Split_Part(duration,' ',1)as integer)  as season_duration
from netflix
where 
	type = 'TV Show' and Cast (Split_Part(duration,' ',1)as integer) >5
group by 1,2
order by 2 desc
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select 
	unnest(string_To_Array(listed_in,',')) as genre,
	count(show_id) as title_count
from netflix
group by 1
order by 2 desc
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select
	*
from netflix
where 
	type = 'Movie' and listed_in ilike '%Documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select 
	*
from netflix
where director is null
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select
	release_year,
	count(show_id) as Movie_count
from netflix
where 
	casts ilike '%Salman Khan%' and release_year > extract(year from current_date) - 10
group by 1
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
select
	unnest(string_to_array(casts,',')) as actor,
	count(*) as Movie_count
from netflix
where 
	country ilike '%India%'
group by 1
order by 2 desc
limit 10
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Rishi Pandey

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated

For more content on SQL, data analysis, and other data-related topics, let's connect

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/rishi-pandey-48a306169/)

Thank you for your support, and I look forward to connecting with you!
