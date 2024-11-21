SELECT *
FROM [Netflix_db].[dbo].[Titles_Netflix]



-- 1. Count number of Movies vs TV shows

SELECT type,
	COUNT(*) as total_content
FROM [Netflix_db].[dbo].[Titles_Netflix]
GROUP BY type

-- 2. Find most frequent rating for movies and TV shows

SELECT rating, COUNT(*) AS frequency
FROM [Netflix_db].[dbo].[Titles_Netflix]
GROUP BY rating
ORDER BY frequency DESC




--3. List all movies released in 2019

SELECT *
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE type = 'Movie' AND release_year = 2019




--4. Identify the top 5 countries with the most content on Netflix

SELECT TOP 5 country, COUNT(*) AS total_content
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC


--5. Identify the longest movie duration

SELECT MAX(duration) AS Max_dur
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE type = 'Movie'


--6. Identify content added in the last 5 years

SELECT *
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE release_year > 2016
ORDER BY release_year DESC


--7. Identify all movies and TV shows by director

SELECT director, type, title
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE director IS NOT NULL
GROUP BY director, type, title


--8. List all TV shows with more than 5 seasons


SELECT *
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE type = 'TV Show'
AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5
	


--9. Count number of content items in each genre


SELECT genre, COUNT(*) AS total_content
FROM (SELECT value AS genre FROM
[Netflix_db].[dbo].[Titles_Netflix]
CROSS APPLY string_split(listed_in, ','))
AS Genres
GROUP BY genre
ORDER BY total_content DESC

--10. Find the average release year for content produced in the United States


SELECT country, AVG(release_year * 1.0) AS average_release_year
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE country = 'United States'
GROUP BY country


--11. List all documentary style movies


SELECT title, type, listed_in
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE  type = 'Movie'
	AND listed_in LIKE '%Documentaries%'
ORDER BY title

--12. Find all content without a director


SELECT title, director
FROM [Netflix_db].[dbo].[Titles_Netflix]
WHERE director IS NULL
ORDER BY title


--13. find the top 10 actors with most casts in USA

SELECT TOP 10 actor, COUNT(*) AS total_casts
FROM (
	SELECT value AS actor
	FROM [Netflix_db].[dbo].[Titles_Netflix]
	CROSS APPLY string_split(cast, ',')
	WHERE country = 'United States')
AS ActorList
GROUP BY actor
ORDER BY total_casts DESC


--14. Categorize the content based on the presence of the keywords 'kill' 'and voilence' in the description feild. 
--Label content containing these keywords as 'evil' and all other content as 'good'. Count how many items fall into each section.

SELECT *,
	CASE
		WHEn description LIKE '%kill%' OR
		description LIKE '%violence%' THEN 'Evil_Content'
		ELSE 'Safe_Content'
	END category
FROM [Netflix_db].[dbo].[Titles_Netflix]