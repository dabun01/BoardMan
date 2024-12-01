-- This file will hold all my sql queries

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