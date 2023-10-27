-- Create tables

CREATE TABLE events
(
	artist VARCHAR(200), 
	auth VARCHAR(200), 
	first_name VARCHAR(200),
	gender VARCHAR(5),
	item_session NUMERIC(10),
	last_name VARCHAR(200), 
	s_length NUMERIC(26, 6), 
	s_level VARCHAR(200), 
	location VARCHAR(200), 
	method VARCHAR(200), 	
	page VARCHAR(200), 
	registration NUMERIC(26, 6), 
	session_id NUMERIC(5), 
	song VARCHAR(200), 
	status NUMERIC(5), 
	ts NUMERIC(26, 6), 
	user_agent VARCHAR(400), 
	user_id NUMERIC(10)
);

CREATE TABLE songs
(
	artist_id VARCHAR(100), 
	artist_latitude NUMERIC(20, 6),
	artist_location VARCHAR(100),
	artist_longitude NUMERIC(20, 6), 
	artist_name VARCHAR(100), 
	duration NUMERIC(20,6),
	num_songs NUMERIC(5), 
	song_id VARCHAR(100),
	title VARCHAR(100),
	release_year NUMERIC(5)
	
);