
DROP SCHEMA IF EXISTS A3GLG CASCADE;
CREATE SCHEMA A3GLG;
SET SEARCH_PATH TO A3GLG;

-- Possible values for level of study.
CREATE TYPE level of study AS ENUM ('undergraduate', 'graduate', 'alumni');
CREATE TYPE role as ENUM ('President', 'Events coordinator', 'Social media coordinator',
'Graphic designer','Treasurer')
CREATE TYPE category as ENUM ('Strategy', 'Party', 'Deck-building', 'Role-building', 
'Social-deduction')
CREATE TYPE physical_condition as ENUM ('New', 'Light_used', 'Worn', 'Implemented', 'Damaged')

CREATE DOMAIN NonNegReal AS REAL CHECK (VALUE >= 0.0);

-- A member, their name <name>, their email <email_id>, 
-- and their level of study <level of study>.
CREATE TABLE member (
    name VARCHAR(200) NOT NULL,
    email_id VARCHAR(500) PRIMARY KEY,
    class level of study NOT NULL
);

-- An executive member, their email <email_id>, their role <role>, 
and the date since they assumed that responsibility <start_date>.
CREATE TABLE exec_member (
    email_id VARCHAR(500) PRIMARY KEY REFERENCES member(email_id)
    class role NOT NULL,
    start_date DATE NOT NULL
);

-- A broad game, identified by its title <title>, has category <category>, 
a minimum player limit <minimum_player_limit>, a maximum player limit <maximum_player_limit>,
publisher <publisher>, and release year <release_year>. 
CREATE TABLE boardGame (
    title VARCHAR(500) PRIMARY KEY,
    minimum_player_limit NonNegReal NOT NULL,
    maximum_player_limit NonNegReal NOT NULL,
    publisher TEXT NOT NULL,
    release_year INT NOT NULL,
    class category NOT NULL
);

-- track_copies
CREATE TABLE track_copies (
    tgid INT PRIMARY KEY,
    game_title VARCHAR(500) NOT NULL REFERENCES broadGame(title),
    class physical_condition NOT NULL,
    acquired_time DATE NOT NULL
)

-- Events
CREATE TABLE event (
    eid INT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    location VARCHAR(500) NOT NULL,
    start_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    end_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
);

-- committee
CREATE TABLE committee (
    cid INT PRIMARY KEY, 
    leader VARCHAR(200) UNIQUE NOT NULL REFERENCES exec_member(email_id)
);

-- committee_fellow
CREATE TABLE committee_fellow (
    cid INT PRIMARY KEY REFERENCES committee(cid),
    fellow VARCHAR(200) NOT NULL REFERENCES exec_member(email_id)
);

-- organize
CREATE TABLE organize (
    cid INT PRIMARY KEY REFERENCES committee(cid),
    eid INT UNIQUE NOT NULL REFERENCES event(eid)
);

-- gameSession
CREATE TABLE gameSession (
    gsid INT PRIMARY KEY,
    game VARCHAR(500) NOT NULL REFERENCES boardGame(title),
    eid INT NOT NULL REFERENCES event(eid),
    facilitator VARCHAR(500) NOT NULL REFERENCES exec_member(email_id),
    Trigger NEEDED
)

-- participant
CREATE TABLE participant (
    gsid INT PRIMARY KEY REFERENCES gameSession(gsid),
    email_id VARCHAR(500) NOT NULL REFERENCES member(email_id),
    Trigger NEEDED
)