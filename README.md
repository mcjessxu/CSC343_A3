# Gotta Love Games (GLG) Database Project

## Overview

Gotta Love Games (GLG) is a student-run club dedicated to board game enthusiasts. The goal of this project was to design a relational database to manage their operations, including tracking inventory, events, and member participation.

## Domain Description

- The club needs to maintain name, email-id and level of study (Undergradute, Graduate, Alumni) of all club members. 

- Executive members of the club that help run the club have extra data associated to them with their current role in club and the date since they assumed that responsibility. All executive members are also members of the club. 

- Board games have titles, category (Strategy, Party, Deck-building, Role-playing, Social-deduction), a mini mum and a maximum player limit, publisher and a release year. The club also wants to track when a game was acquired and the physical condition (New, Lightly-used, Worn, Incomplete, Damaged) it is currently in. “Incomplete” games can still be played while “Damaged” ones cannot. • GLG owns multiple copies of some games and that needs to be tracked.

- GLG holds several events which have a name, location and date.

- Events with the same name can occur multiple times. For example, they hold a weekly event that happens every week and some special events that happen once in a term or year.

- There can be multiple game sessions held at any event each involving a particular board game that was played by some members of the club and is facilitated by one exec member of the club.

- All game sessions are assumed to run for the entire duration of the event. No member can participate in two game sessions happening at the same time.

- No exec member should be facilitating two game sessions at once. They should also not be playing any other game while they are facilitating a game session, they can however be playing the same game as they are facilitating. 

- Events have an organizing committee which is comprised of multiple exec members (one of which is a organizing lead) and must always have a lead exec member. The organizing team stays the same for the multiple occurences of any event. For example, all weekly game nights are organied by the same exec team.

## Notes

Some assumptions and constraints were simplified to support focused learning outcomes (e.g., all sessions span the entire event, event committees do not change). Where no constraint was mentioned, the design assumes the entity is unconstrained.

## Relational Model (Draft for schema.ddl)
Member (mid, name, email_id, level of study)
    
  - level of study = {Undergraduate, Graduate, Alumni}
    
ExecMember (mid, role, start_date)
    
  - ExecMember[mid] $\subseteq$ Member[mid]
    
  - Role = {President, …}
    
BoardGame (game_id, title, minimum player limit, maximum player limit, publisher, release year, category)
    
  - category = {Strategy, Party, Deck-building, Role-playing, Social-deduction}
    
TrackCopies (gcopy_id, game_id, physical_condition, acquired_time)
    
  - physical_condition = {New, Light_used, Worn, Implemented, Damaged}
    
  - TrackCopies[game_id]  $\subseteq$ BoardGame[game_id]
    
Event (eid, name, location, start_datetime, end_datetime)
Committee (cid, leader)
    
  - Committee[leader] $\subseteq$ ExecMember[mid]
    
CommitteeFellow (cid, fellow)
    
  - CommitteeFellow[cid] $\subseteq$ Committee[cid]
    
  - CommitteeFellow[fellow] $\subseteq$ ExecMember[mid]
    
Organize (cid, eid)
    
  - Organize[cid] $\subseteq$ Committee[cid]
    
  - Organize[eid] $\subseteq$ Event[id]
    
GameSession (gsid, game_id, eid, facilitator)
    
  - GameSession[game_id] $\subseteq$ BoardGame[game_id]
    
  - GameSession[gcopy_id] $\subseteq$ TrackCopies[tgid]
    
  - GameSession[eid] $\subseteq$ Event[id]
    
  - GameSession[facilitator] $\subseteq$ ExecMember [mid]
    
  - Trigger NEEDED

UsedCopy (gsid, gcopy_id)
    
  - UsedCopy[gsid] $\subseteq$ GameSession [game_id]
    
  - UsedCopy[gcopy_id] $\subseteq$ TrackCopies[gcopy_id]
    
Participant(gsid, mid)
    
  - Participant[gsid] $\subseteq$ GameSession[gsid]
    
  - Participant[mid] $\subseteq$ member[mid]
    
  - Trigger NEEDED
