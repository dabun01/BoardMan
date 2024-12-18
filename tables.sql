/* This script file creates the following tables:	*/
/* PLAYER, TEAM, CONFERENCE	*/
/* and loads the data rows  */
BEGIN;

-- Dropping Database if it exists
DROP DATABASE IF EXISTS NBA;

CREATE DATABASE NBA;

USE NBA;

-- Dropping tables if they exist
DROP TABLE IF EXISTS PLAYER;

DROP TABLE IF EXISTS TEAM;

DROP TABLE IF EXISTS CONFERENCE;

CREATE TABLE CONFERENCE (
        C_NAME VARCHAR(35) NOT NULL,
        C_ABBREVIATION VARCHAR(15) NOT NULL, -- Add conference abbreviation (e.g., "West", "East")
        C_TEAMS INT NOT NULL,
        C_TITLES INT,
        PRIMARY KEY (C_NAME),
        UNIQUE (C_ABBREVIATION) -- Ensure conference abbreviations are unique
    );

CREATE TABLE TEAM (
        T_NAME VARCHAR(35) NOT NULL,
        T_ABBREVIATION VARCHAR(5) NOT NULL, -- Add team abbreviation (e.g., "LAL", "BOS")
        T_SEED INT NOT NULL,
        T_WINS INT NOT NULL,
        T_LOSSES INT NOT NULL,
        C_ABBREVIATION VARCHAR(5) NOT NULL, -- Reference conference abbreviation
        PRIMARY KEY (T_NAME),
        UNIQUE (T_ABBREVIATION), -- Ensure team abbreviations are unique
        CONSTRAINT FK_TEAM_CONFERENCE FOREIGN KEY (C_ABBREVIATION) REFERENCES CONFERENCE (C_ABBREVIATION)
    );

CREATE TABLE PLAYER (
        P_NUMBER INT NOT NULL,
        P_NAME VARCHAR(35) NOT NULL,
        P_POSITION VARCHAR(2) NOT NULL,
        P_PTS INT NOT NULL,
        P_REB INT NOT NULL,
        P_AST INT NOT NULL,
        P_FG DECIMAL(5, 2) NOT NULL,
        P_TEAM_ABBR VARCHAR(5) NOT NULL, -- Reference team abbreviation instead of full name
        PRIMARY KEY (P_NAME),
        CONSTRAINT FK_PLAYER_TEAM FOREIGN KEY (P_TEAM_ABBR) REFERENCES TEAM (T_ABBREVIATION)
    );

-- Loading data into the tables
-- Conference table
INSERT INTO
    CONFERENCE
VALUES
    ('Eastern Conference', 'East', 15, 25);

INSERT INTO
    CONFERENCE
VALUES
    ('Western Conference', 'West', 15, 29);

-- Team table
INSERT INTO TEAM VALUES
    -- Eastern Conference
    ('Atlanta Hawks', 'ATL', 9, 8, 11, 'East'),
    ('Boston Celtics', 'BOS', 2, 15, 3, 'East'),
    ('Brooklyn Nets', 'BKN', 8, 9, 10, 'East'),
    ('Charlotte Hornets', 'CHA', 12, 6, 12, 'East'),
    ('Chicago Bulls', 'CHI', 10, 8, 12, 'East'),
    ('Cleveland Cavaliers', 'CLE', 1, 17, 2, 'East'),
    ('Detroit Pistons', 'DET', 11, 8, 12, 'East'),
    ('Indiana Pacers', 'IND', 7, 9, 10, 'East'),
    ('Miami Heat', 'MIA', 6, 8, 8, 'East'),
    ('Milwaukee Bucks', 'MIL', 5, 9, 9, 'East'),
    ('New York Knicks', 'NYK', 4, 10, 8, 'East'),
    ('Orlando Magic', 'ORL', 3, 13, 7, 'East'),
    ('Philadelphia 76ers', 'PHI', 14, 3, 14, 'East'),
    ('Toronto Raptors', 'TOR', 13, 5, 14, 'East'),
    ('Washington Wizards', 'WAS', 15, 2, 15, 'East'),
    -- Western Conference
    ('Dallas Mavericks', 'DAL', 8, 11, 8, 'West'),
    ('Denver Nuggets', 'DEN', 7, 10, 7, 'West'),
    ('Golden State Warriors', 'GSW', 3, 12, 6, 'West'),
    ('Houston Rockets', 'HOU', 2, 14, 6, 'West'),
    ('Los Angeles Clippers', 'LAC', 6, 12, 8, 'West'),
    ('Los Angeles Lakers', 'LAL', 5, 11, 7, 'West'),
    ('Memphis Grizzlies', 'MEM', 4, 12, 7, 'West'),
    ('Minnesota Timberwolves','MIN', 12, 8, 10,'West'),
    ('New Orleans Pelicans', 'NOP', 15, 4, 15, 'West'),
    ('Oklahoma City Thunder', 'OKC', 1, 14, 4, 'West'),
    ('Phoenix Suns', 'PHX', 9, 10, 8, 'West'),
    ('Portland Trail Blazers','POR', 13, 7, 12,'West'),
    ('Sacramento Kings', 'SAC', 11, 9, 10, 'West'),
    ('San Antonio Spurs', 'SAS', 10, 10, 9, 'West'),
    ('Utah Jazz', 'UTA', 14, 4, 14, 'West');

-- Player table
INSERT INTO PLAYER (P_NUMBER, P_NAME, P_POSITION, P_PTS, P_REB, P_AST, P_FG, P_TEAM_ABBR) VALUES
-- Atlanta Hawks
    (1, 'Jalen Johnson', 'SF', 19, 10, 5, '0.45', 'ATL'),
    (11, 'Trae Young', 'PG', 24, 4, 12, '0.39', 'ATL'),
    (5, 'Dyson Daniels', 'SG', 14, 4, 3, '0.47', 'ATL'),
    (10, 'Zaccharie Risacher', 'SF', 12, 4, 1, '0.37', 'ATL'),
    (15, 'Clint Capela', 'C', 11, 7, 1, '0.66', 'ATL'),
-- Boston Celtics
    (7, 'Jaylen Brown', 'SF', 26, 7, 4, '0.42', 'BOS'),
    (0, 'Jayson Tatum', 'SF', 30, 8, 5, '0.46', 'BOS'),
    (9, 'Derrick White', 'SG', 20, 5, 4, '0.49', 'BOS'),
    (4, 'Jrue Holiday', 'PG', 13, 4, 4, '0.48', 'BOS'),
    (42, 'Al Horford', 'C', 9, 6, 2, '0.49', 'BOS'),
-- Brooklyn Nets
    (17, 'Dennis Schröder', 'PG', 20, 3, 6, '0.48', 'BKN'),
    (24, 'Cam Thomas', 'SG', 24, 3, 3, '0.43', 'BKN'),
    (2, 'Cameron Johnson', 'PF', 17, 4, 3, '0.47', 'BKN'),
    (28, 'Dorian Finney-Smith', 'PF', 10, 5, 2, '0.44', 'BKN'),
    (33, 'Nic Claxton', 'C', 9, 8, 3, '0.67', 'BKN'),
-- Charlotte Hornets
    (1, 'LaMelo Ball', 'PG', 30, 5, 6, '0.45', 'CHA'),
    (0, 'Miles Bridges', 'SF', 15, 7, 3, '0.39', 'CHA'),
    (24, 'Brandon Miller', 'SF', 16, 4, 4, '0.37', 'CHA'),
    (2, 'Grant Williams', 'PF', 10, 5, 2, '0.44', 'CHA'),
    (4, 'Nick Richards', 'C', 11, 10, 2, '0.64', 'CHA'),
-- Chicago Bulls
    (8, 'Zach LaVine', 'SF', 22, 5, 4, '0.51', 'CHI'),
    (0, 'Coby White', 'SG', 18, 4, 5, '0.44', 'CHI'),
    (9, 'Nikola Vučević', 'C', 21, 10, 3, '0.58', 'CHI'),
    (11, 'Ayo Dosunmu', 'SG', 12, 4, 4, '0.48', 'CHI'),
    (44, 'Patrick Williams', 'PF', 10, 5, 2, '0.38', 'CHI'),
-- Cleveland Cavaliers
    (45, 'Donovan Mitchell', 'SG', 24, 5, 4, '0.45', 'CLE'),
    (4, 'Evan Mobley', 'PF', 18, 9, 3, '0.56', 'CLE'),
    (10, 'Darius Garland', 'PG', 21, 2, 7, '0.50', 'CLE'),
    (31, 'Jarrett Allen', 'C', 15, 11, 2, '0.70', 'CLE'),
    (3, 'Caris LeVert', 'SG', 12, 3, 4, '0.53', 'CLE'),

-- Dallas Mavericks
    (77, 'Luka Dončić', 'PG', 28, 8, 8, '0.44', 'DAL'),
    (11, 'Kyrie Irving', 'SG', 24, 5, 5, '0.51', 'DAL'),
    (25, 'P.J. Washington', 'PF', 12, 9, 2, '0.45', 'DAL'),
    (31, 'Klay Thompson', 'SF', 13, 4, 2, '0.38', 'DAL'),
    (2, 'Dereck Lively II', 'C', 9, 7, 2, '0.71', 'DAL'),
-- Denver Nuggets
    (15, 'Nikola Jokić', 'C', 30, 13, 11, '0.57', 'DEN'),   
    (1, 'Michael Porter Jr.', 'SF', 19, 7, 3, '0.49', 'DEN'),
    (27, 'Jamal Murray', 'PG', 18, 4, 6, '0.42', 'DEN'),
    (0, 'Christian Braun', 'SG', 16, 5, 2, '0.58', 'DEN'),
    (32, 'Aaron Gordon', 'PF', 15, 7, 3, '0.53', 'DEN'),
-- Detroit Pistons
    (2, 'Cade Cunningham', 'PG', 24, 7, 9, '0.44', 'DET'),
    (12, 'Tobias Harris', 'PF', 14, 7, 3, '0.45', 'DET'),
    (23, 'Jaden Ivey', 'SG', 19, 4, 4, '0.46', 'DET'),
    (5, 'Malik Beasley', 'SG', 16, 3, 2, '0.43', 'DET'),
    (0, 'Jalen Duren', 'C', 9, 10, 3, '0.69', 'DET'),
-- Golden State Warriors
    (30, 'Stephen Curry', 'PG', 22, 5, 7, '0.48', 'GSW'),
    (23, 'Draymond Green', 'PF', 9, 6, 6, '0.42', 'GSW'),
    (22, 'Andrew Wiggins', 'SF', 17, 4, 2, '0.46', 'GSW'),
    (7, 'Buddy Hield', 'SG', 16, 4, 2, '0.47', 'GSW'),
    (0, 'Jonathan Kuminga', 'PF', 14, 4, 2, '0.44', 'GSW'),
-- Houston Rockets
    (1, 'Fred VanVleet', 'PG', 15, 4, 6, '0.39', 'HOU'),
    (5, 'Jalen Green', 'SG', 19, 5, 3, '0.39', 'HOU'),
    (9, 'Dillon Brooks', 'SF', 12, 4, 2, '0.41', 'HOU'),
    (28, 'Alperen Sengun', 'C', 19, 11, 5, '0.48', 'HOU'),
    (10, 'Jabari Smith Jr.', 'PF', 12, 7, 1, '0.45', 'HOU'),

-- Indiana Pacers
    (0, 'Tyrese Haliburton', 'PG', 18, 4, 9, '0.41', 'IND'),
    (43, 'Pascal Siakam', 'PF', 21, 7, 4, '0.55', 'IND'),
    (00, 'Bennedict Mathurin', 'SG', 18, 7, 2, '0.49', 'IND'),
    (33, 'Myles Turner', 'C', 16, 8, 1, '0.48', 'IND'),
    (2, 'Andrew Nembhard', 'SG', 7, 2, 5, '0.39', 'IND'),

-- Los Angeles Clippers
    (1, 'James Harden', 'PG', 22, 7, 9, '0.39', 'LAC'),
    (24, 'Norman Powell', 'SG', 23, 3, 2, '0.49', 'LAC'),
    (40, 'Ivica Zubac', 'C', 16, 13, 2, '0.62', 'LAC'),
    (55, 'Derrick Jones Jr.', 'SF', 10, 4, 1, '0.50', 'LAC'),
    (7, 'Amir Coffey', 'SG', 10, 2, 1, '0.47', 'LAC'),

-- Los Angeles Lakers
    (3, 'Anthony Davis', 'C', 28, 12, 3, '0.56', 'LAL'),
    (23, 'LeBron James', 'SF', 22, 8, 9, '0.50', 'LAL'),
    (15, 'Austin Reaves', 'SG', 17, 4, 5, '0.44', 'LAL'),
    (28, 'Rui Hachimura', 'PF', 12, 5, 2, '0.44', 'LAL'),
    (4, 'Dalton Knecht', 'SF', 12, 3, 1, '0.50', 'LAL'),

-- Memphis Grizzlies
    (13, 'Jaren Jackson Jr.', 'C', 22, 6, 1, '0.52', 'MEM'),
    (7, 'Santi Aldama', 'PF', 13, 8, 3, '0.50', 'MEM'),
    (12, 'Ja Morant', 'PG', 21, 4, 9, '0.47', 'MEM'),
    (22, 'Desmond Bane', 'SG', 14, 6, 4, '0.41', 'MEM'),
    (0, 'Jaylen Wells', 'SG', 12, 3, 2, '0.45', 'MEM'),

-- Miami Heat
    (13, 'Bam Adebayo', 'C', 16, 9, 5, '0.43', 'MIA'),
    (14, 'Tyler Herro', 'SG', 24, 5, 5, '0.47', 'MIA'),
    (22, 'Jimmy Butler', 'PF', 19, 5, 5, '0.53', 'MIA'),
    (2, 'Terry Rozier', 'PG', 13, 4, 3, '0.40', 'MIA'),
    (24, 'Haywood Highsmith', 'SF', 7, 3, 1, '0.49', 'MIA'),

-- Milwaukee Bucks
    (0, 'Damian Lillard', 'PG', 26, 5, 8, '0.44', 'MIL'),
    (34, 'Giannis Antetokounmpo', 'PF', 32, 12, 6, '0.61', 'MIL'),
    (11, 'Brook Lopez', 'C', 12, 5, 2, '0.48', 'MIL'),
    (12, 'Taurean Prince', 'SF', 9, 5, 2, '0.49', 'MIL'),
    (5, 'Gary Trent Jr.', 'SG', 9, 2, 1, '0.38', 'MIL'),

-- Minnesota Timberwolves
    (5, 'Anthony Edwards', 'SG', 28, 5, 4, '0.45', 'MIN'),
    (27, 'Rudy Gobert', 'C', 10, 11, 2, '0.64', 'MIN'),
    (30, 'Julius Randle', 'PF', 21, 7, 4, '0.50', 'MIN'),
    (3, 'Jaden McDaniels', 'PF', 10, 4, 2, '0.44', 'MIN'),
    (10, 'Mike Conley', 'PG', 9, 3, 5, '0.33', 'MIN'),

-- New Orleans Pelicans
    (14, 'Brandon Ingram', 'SF', 23, 6, 5, '0.47', 'NOP'),
    (3, 'CJ McCollum', 'PG', 21, 4, 3, '0.45', 'NOP'),
    (25, 'Trey Murphy III', 'SF', 19, 6, 2, '0.41', 'NOP'),
    (1, 'Zion Williamson', 'PF', 23, 8, 5, '0.45', 'NOP'),
    (5, 'Dejounte Murray', 'PG', 16, 6, 6, '0.31', 'NOP'),

-- New York Knicks
    (25, 'Mikal Bridges', 'SF', 16, 4, 3, '0.45', 'NYK'),
    (3, 'Josh Hart', 'SG', 14, 9, 6, '0.59', 'NYK'),
    (8, 'OG Anunoby', 'PF', 18, 5, 2, '0.49', 'NYK'),
    (11, 'Jalen Brunson', 'PG', 26, 3, 8, '0.49', 'NYK'),
    (32, 'Karl-Anthony Towns', 'C', 26, 13, 3, '0.54', 'NYK'),

-- Oklahoma City Thunder
    (2, 'Shai Gilgeous-Alexander', 'SG', 30, 5, 7, '0.50', 'OKC'),
    (55, 'Isaiah Hartenstein', 'C', 14, 14, 4, '0.57', 'OKC'),
    (8, 'Jalen Williams', 'SG', 22, 6, 5, '0.52', 'OKC'),
    (5, 'Luguentz Dort', 'SG', 10, 5, 2, '0.42', 'OKC'),
    (7, 'Chet Holmgren', 'C', 16, 9, 2, '0.51', 'OKC'),
    -- Orlando Magic
    (1, 'Paolo Banchero', 'PF', 29, 9, 6, '0.50', 'ORL'),
    (22, 'Franz Wagner', 'SF', 24, 6, 6, '0.47', 'ORL'),
    (3, 'Kentavious Caldwell-Pope', 'SG', 8, 2, 2, '0.40', 'ORL'),
    (4, 'Jalen Suggs', 'PG', 15, 4, 4, '0.42', 'ORL'),
    (34, 'Wendell Carter Jr.', 'C', 8, 8, 2, '0.48', 'ORL'),
-- Philadelphia 76ers
    (0, 'Tyrese Maxey', 'PG', 26, 3, 4, '0.41', 'PHI'),
    (21, 'Joel Embiid', 'C', 20, 8, 4, '0.38', 'PHI'),
    (9, 'Kelly Oubre Jr.', 'SF', 13, 5, 1, '0.42', 'PHI'),
    (8, 'Paul George', 'PF', 15, 5, 5, '0.38', 'PHI'),
    (20, 'Jared McCain', 'SG', 16, 2, 3, '0.45', 'PHI'),
-- Phoenix Suns
    (35, 'Kevin Durant', 'PF', 27, 7, 3, '0.55', 'PHX'),
    (1, 'Devin Booker', 'SG', 25, 4, 7, '0.45', 'PHX'),
    (3, 'Bradley Beal', 'SG', 18, 4, 3, '0.50', 'PHX'),
    (21, 'Tyus Jones', 'PG', 11, 3, 7, '0.45', 'PHX'),
    (20, 'Jusuf Nurkić', 'C', 9, 10, 1, '0.42', 'PHX'),
-- Portland Trail Blazers
    (9, 'Jerami Grant', 'PF', 16, 3, 2, '0.38', 'POR'),
    (33, 'Toumani Camara', 'PF', 9, 5, 2, '0.41', 'POR'),
    (1, 'Anfernee Simons', 'SG', 17, 3, 4, '0.39', 'POR'),
    (2, 'Deandre Ayton', 'C', 15, 11, 1, '0.54', 'POR'),
    (17, 'Shaedon Sharpe', 'SG', 18, 3, 2, '0.43', 'POR'),
-- Sacramento Kings
    (5, 'De''Aaron Fox', 'PG', 28, 5, 6, '0.50', 'SAC'),
    (13, 'Keegan Murray', 'PF', 12, 8, 2, '0.41', 'SAC'),
    (11, 'Domantas Sabonis', 'C', 20, 13, 6, '0.63', 'SAC'),
    (10, 'DeMar DeRozan', 'SF', 23, 4, 4, '0.51', 'SAC'),
    (0, 'Malik Monk', 'SG', 15, 3, 4, '0.46', 'SAC'),
-- San Antonio Spurs
    (1, 'Victor Wembanyama', 'C', 23, 10, 3, '0.47', 'SAS'),
    (40, 'Harrison Barnes', 'PF', 12, 5, 2, '0.52', 'SAS'),
    (10, 'Jeremy Sochan', 'PF', 15, 8, 3, '0.51', 'SAS'),
    (3, 'Chris Paul', 'PG', 11, 4, 8, '0.46', 'SAS'),
    (5, 'Stephon Castle', 'PG', 12, 3, 4, '0.40', 'SAS'),
-- Toronto Raptors
    (9, 'RJ Barrett', 'SG', 23, 6, 6, '0.44', 'TOR'),
    (4, 'Scottie Barnes', 'PF', 20, 9, 7, '0.43', 'TOR'),
    (1, 'Gradey Dick', 'SG', 18, 3, 2, '0.42', 'TOR'),
    (19, 'Jakob Poeltl', 'C', 16, 12, 2, '0.60', 'TOR'),
    (30, 'Ochai Agbaji', 'SG', 12, 5, 2, '0.54', 'TOR'),
-- Utah Jazz
    (3, 'Keyonte George', 'PG', 16, 3, 6, '0.38', 'UTA'),
    (23, 'Lauri Markkanen', 'PF', 20, 7, 2, '0.47', 'UTA'),
    (20, 'John Collins', 'PF', 18, 9, 3, '0.54', 'UTA'),
    (2, 'Collin Sexton', 'SG', 17, 2, 3, '0.48', 'UTA'),
    (24, 'Walker Kessler', 'C', 10, 10, 1, '0.70', 'UTA'),
-- Washington Wizards
    (0, 'Bilal Coulibaly', 'SF', 13, 6, 3, '0.49', 'WAS'),
    (13, 'Jordan Poole', 'SG', 20, 2, 5, '0.45', 'WAS'),
    (24, 'Corey Kispert', 'SF', 11, 3, 2, '0.41', 'WAS'),
    (33, 'Kyle Kuzma', 'PF', 16, 6, 2, '0.42', 'WAS'),
    (20, 'Alex Sarr', 'C', 11, 6, 2, '0.38', 'WAS');

COMMIT;