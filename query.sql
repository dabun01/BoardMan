-- This file will hold all my sql queries
-- This is all the SQL queries used on the stats.py file
-- I have made a few changes to the queries to make them more readable

-- Get all teams
SELECT T_NAME FROM TEAM;

-- Get all players
SELECT P_NAME FROM PLAYER ORDER BY P_NAME;

-- Search for a player by name
SELECT * FROM PLAYER WHERE P_NAME = "Victor Wembanyama";

-- Get the stats of the selected team
select T_NAME, T_SEED, T_WINS, T_LOSSES, 
(T_WINS / (T_WINS + T_LOSSES)) as WIN_PERCENTAGE 
from TEAM 
where T_NAME = "San Antonio Spurs";

-- Get the stats of the player on the selected team
select P_NUMBER, P_NAME, P_POSITION, P_PTS, P_AST, P_REB, P_FG, T_NAME 
FROM PLAYER JOIN TEAM ON P_TEAM_ABBR = T_ABBREVIATION 
WHERE T_NAME = "San Antonio Spurs";

-- Search players by name
SELECT P_NAME FROM PLAYER WHERE LOWER(P_NAME) LIKE '%steph%';

-- Search team by conference
SELECT T_NAME FROM TEAM WHERE LOWER(C_ABBREVIATION) LIKE '%s' ORDER BY T_SEED

-- Get the stats of all the team in the selected conference
select T_NAME, T_SEED, T_WINS, T_LOSSES, (T_WINS / (T_WINS + T_LOSSES)) as WIN_PERCENTAGE 
from TEAM  where C_ABBREVIATION LIKE '%s' ORDER BY T_SEED

-- Extra queries for testing
-- Get all players
SELECT * FROM PLAYER;

--get one specific player
SELECT * FROM PLAYER WHERE P_NAME = "LeBron James";

-- Get all players by team
select *
from PLAYER
where P_TEAM_ABBR = 'DEN';

-- Get all players who average more than 20 points and sort by points
select *
from PLAYER
where P_PTS > 20
order by P_PTS desc;

-- Get all players by position
SELECT * FROM PLAYER WHERE P_POSITION = "PG";

-- Get all teams in the league
SELECT * FROM TEAM;

-- Get all teams by conference
select T_NAME, T_SEED, T_WINS, T_LOSSES 
from TEAM where C_ABBREVIATION = "East";

select T_NAME, T_SEED, T_WINS, T_LOSSES 
from TEAM where C_ABBREVIATION = "West";

-- Get all teams by conference and sorted by seed
select T_NAME, T_SEED, T_WINS, T_LOSSES
from TEAM where C_ABBREVIATION = "East"
order by T_SEED;

-- Get all teams by conference and calculate win percentage
select T_NAME, T_SEED, T_WINS, T_LOSSES, (T_WINS / (T_WINS + T_LOSSES)) as WIN_PERCENTAGE
from TEAM where C_ABBREVIATION = "East"
order by WIN_PERCENTAGE desc;