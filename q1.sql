create or replace view Event_with_games as
SELECT distinct gs.eid
FROM GameSession gs;

create or replace view Should_have_participated as
SELECT m.mid AS mid, eg.eid AS eid
FROM Event_with_games eg, MEMBER m;

create or replace view Did_not_participat as
(SELECT shp.mid, shp.eid
FROM Should_have_participated shp)
EXCEPT
(SELECT p.mid, gs.eid
FROM Participant p
JOIN GameSession gs on  p.gsid = gs.gsid);

create or replace view Ans as
(SELECT mid
FROM MEMBER)
EXCEPT
(SELECT DISTINCT mid
FROM Did_not_participat);

SELECT Round(COUNT (DISTINCT Ans.mid) *100.0 / (SELECT COUNT(*) FROM MEMBER))
FROM Ans;
