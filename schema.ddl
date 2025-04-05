
DROP SCHEMA IF EXISTS A3GLG CASCADE;
CREATE SCHEMA A3GLG;
SET SEARCH_PATH TO A3GLG;

-- Possible values for level_of_study.
CREATE TYPE level_of_study AS ENUM ('undergraduate', 'graduate', 'alumni');
CREATE TYPE role as ENUM ('President', 'Events coordinator', 'Social media coordinator',
'Graphic designer','Treasurer');
CREATE TYPE category as ENUM ('Strategy', 'Party', 'Deck-building', 'Role-building', 
'Social-deduction');
CREATE TYPE physical_condition as ENUM ('New', 'Light_used', 'Worn', 'Implemented', 'Damaged');

CREATE DOMAIN NonNegReal AS REAL CHECK (VALUE >= 0.0);

-- A member, their name <name>, their email <email_id>, 
-- and their level_of_study <level_of_study>.
CREATE TABLE Member (
    name VARCHAR(200) NOT NULL,
    email_id VARCHAR(500) PRIMARY KEY,
    class level_of_study NOT NULL
);

-- An executive member, their email <email_id>, their role <role>, 
-- and the date since they assumed that responsibility <start_date>.
CREATE TABLE ExecMember (
    email_id VARCHAR(500) PRIMARY KEY REFERENCES member(email_id),
    class role NOT NULL,
    start_date DATE NOT NULL
);

-- A board game, identified by its title <title>, has category <category>, 
-- a minimum player limit <minimum_player_limit>, a maximum player limit <maximum_player_limit>,
-- publisher <publisher>, and release year <release_year>. 
CREATE TABLE BoardGame (
    title VARCHAR(500) PRIMARY KEY,
    minimum_player_limit NonNegReal NOT NULL,
    maximum_player_limit NonNegReal NOT NULL,
    publisher TEXT NOT NULL,
    release_year INT NOT NULL,
    class category NOT NULL
);

-- track_copies
CREATE TABLE TrackCopies (
    tgid INT PRIMARY KEY,
    game_title VARCHAR(500) NOT NULL REFERENCES boardGame(title),
    class physical_condition NOT NULL,
    acquired_time DATE NOT NULL
);

-- Events
CREATE TABLE Event (
    eid INT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    location VARCHAR(500) NOT NULL,
    start_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    end_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

-- Committee
CREATE TABLE Committee (
    cid INT PRIMARY KEY, 
    leader VARCHAR(200) UNIQUE NOT NULL REFERENCES ExecMember(email_id)
);

-- CommitteeFellow
CREATE TABLE CommitteFellow (
    cid INT PRIMARY KEY REFERENCES Committee(cid),
    fellow VARCHAR(200) NOT NULL REFERENCES ExecMember(email_id)
);

-- Organize
CREATE TABLE Organize (
    cid INT PRIMARY KEY REFERENCES Committee(cid),
    eid INT UNIQUE NOT NULL REFERENCES event(eid)
);

-- GameSession
CREATE TABLE GameSession (
    gsid INT PRIMARY KEY,
    game VARCHAR(500) NOT NULL REFERENCES boardGame(title),
    eid INT NOT NULL REFERENCES event(eid),
    facilitator VARCHAR(500) NOT NULL REFERENCES ExecMember(email_id)
);

-- Trigger for ensuring one exec member facilitate only one event
-- at the same time.
CREATE OR REPLACE FUNCTION check_facilitator_conflict()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM GameSession GS
        JOIN Event E1 ON GS.eid = E1.eid
        JOIN Event E2 ON NEW.eid = E2.eid
        WHERE 
            GS.facilitator = NEW.facilitator
            AND GS.gsid <> NEW.gsid
            AND (
                E1.start_datetime, E1.end_datetime
            ) OVERLAPS (
                E2.start_datetime, E2.end_datetime
            )
    ) THEN
        RAISE EXCEPTION 'Member % is already facilitating another game session at the same time.', NEW.facilitator;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER facilitator_trg
BEFORE INSERT OR UPDATE ON GameSession
FOR EACH ROW
EXECUTE FUNCTION check_facilitator_conflict();

-- participant
CREATE TABLE participant (
    gsid INT PRIMARY KEY REFERENCES gameSession(gsid),
    email_id VARCHAR(500) NOT NULL REFERENCES member(email_id)
);

-- Trigger for ensuring one member can only participate in only
-- one game session at the same time.
CREATE OR REPLACE FUNCTION check_participant_conflict()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM (GameSession natural join Participant
        natural join Event) orig_p
        JOIN (GameSession natural join Event) new_p ON NEW.gsid = new_p.gsid
        WHERE 
            orig_p.email_id = NEW.email_id
            AND orig_p.gsid <> NEW.gsid
            AND (
                orig_p.start_datetime, orig_p.end_datetime
            ) OVERLAPS (
                new_p.start_datetime, new_p.end_datetime
            )
    ) THEN
        RAISE EXCEPTION 'Member % is already participate another game session at the same time.', NEW.email_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER participant_trg
BEFORE INSERT OR UPDATE ON Participant
FOR EACH ROW
EXECUTE FUNCTION check_participant_conflict();