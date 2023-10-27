-- Select all values from events and songs

SELECT * 
FROM events;

SELECT * 
FROM songs;

-- Count all values of artists

SELECT COUNT(*) AS count_artist 
FROM events;

-- Count distinct artists

SELECT COUNT(DISTINCT(artist)) AS count_artist 
FROM events;

-- Select distinct session_id

SELECT DISTINCT(session_id)
FROM events;

-- Select distinct session_id and other columns

SELECT first_name, last_name, gender, session_id
FROM   (
         SELECT first_name, last_name, gender, session_id,
         ROW_NUMBER() OVER(PARTITION BY  session_id ORDER BY first_name) rn
         FROM   events
       ) t1
    WHERE  rn = 1 
	
-- Count songs per artist
SELECT artist, COUNT(*) AS count_songs
FROM events
GROUP BY artist
ORDER BY count_songs DESC, artist ASC;

-- Count distinct songs per artist
SELECT artist, COUNT(DISTINCT song) AS count_dist_songs
FROM events
GROUP BY artist
ORDER BY count_dist_songs DESC, artist ASC;

-- Find the average songs per artist
SELECT artist, AVG(s_length) AS avg_length
FROM events
GROUP BY artist
ORDER BY avg_length DESC, artist ASC;

-- Count distinct songs per artist and keep just artists with 10 or more distinct songs
SELECT artist, COUNT(DISTINCT song) as count_dist_songs
FROM events
GROUP BY artist
HAVING COUNT(DISTINCT song) >= 10
ORDER BY count_dist_songs DESC, artist ASC;

-- Filter by gender F
SELECT *
FROM events
WHERE gender = 'F'

-- Count distinct songs per artist where user gender is M
SELECT DISTINCT artist, COUNT(DISTINCT song) as count_dist_songs
FROM events
WHERE song IN
    (SELECT song
    FROM events
    WHERE gender = 'M')
GROUP BY artist
ORDER BY count_dist_songs DESC, artist ASC;

-- Count distinct songs per artist where user gender is M
SELECT DISTINCT artist, COUNT(DISTINCT song) as count_dist_songs
FROM events
WHERE song IN
    (SELECT song
    FROM events
    WHERE gender = 'M')
GROUP BY artist
ORDER BY count_dist_songs DESC, artist ASC;

-- Join tables by artists name
SELECT e.artist, e.song, e.s_level, s.artist_name, s.duration, s.title, s.release_year
FROM events AS e
INNER JOIN songs AS s
ON e.artist = s.artist_name;

-- How long each user spend in the website

SELECT user_id, DENSE_RANK() OVER(ORDER BY user_time DESC), first_name, last_name, user_time
FROM (
		SELECT DISTINCT user_id, first_name, last_name, 
		SUM(s_length) OVER(PARTITION BY user_id) AS user_time
		FROM events
		WHERE song IS NOT NULL AND page = 'NextSong'
     ) sub_query;

-- Get most played songs in total sessions by number of users with length, artist and rank 

SELECT * , DENSE_RANK() OVER(ORDER BY users_number DESC) 
FROM
	(SELECT DISTINCT song, artist, COUNT(user_id) OVER (PARTITION BY song) AS users_number
	FROM events
	WHERE page = 'NextSong'
	) sub_query
WHERE song IS NOT NULL;

-- Order of artists according to the number of songs 

SELECT *, DENSE_RANK() OVER(ORDER BY songs_number DESC) 
FROM 
	(
	SELECT DISTINCT artist, COUNT(song) OVER(PARTITION BY artist) songs_number
	FROM events
	WHERE song IS NOT NULL) sub_query;

-- Get the most users contribute to the system according to the songs they heard

SELECT *, DENSE_RANK() OVER(ORDER BY songs_number DESC) AS user_rank
FROM 
		(
		SELECT DISTINCT user_id, first_name, last_name, gender, COUNT(song) OVER (PARTITION BY user_id) AS songs_number
		FROM events
		WHERE song IS NOT NULL AND page = 'NextSong') sub_query;

-- Get the longest and shortest song 

SELECT  song, s_length 
FROM events
WHERE song IS NOT NULL AND page = 'NextSong'
ORDER BY s_length DESC
LIMIT 1;

SELECT  song, s_length 
FROM events
WHERE song IS NOT NULL AND page = 'NextSong'
ORDER BY s_length ASC
LIMIT 1;

-- Get the number of paid songs by user

SELECT user_id, first_name, last_name, paid_songs_number, free_songs_number, 
CAST (paid_songs_number AS FLOAT) / (paid_songs_number + free_songs_number) paid_songs_percentage
FROM 
	(
	SELECT DISTINCT user_id, first_name, last_name,
	COUNT(CASE WHEN s_level = 'paid' THEN 1 END) OVER(PARTITION BY user_id) paid_songs_number, 
	COUNT(CASE WHEN s_level = 'free' THEN 1 END) OVER(PARTITION BY user_id) free_songs_number
	FROM events
	WHERE song IS NOT NULL AND page = 'NextSong') sub_query
ORDER BY user_id;

