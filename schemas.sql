-- SCHEMAS of Netflix

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
