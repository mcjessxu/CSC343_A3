create or replace view Participant_each_event as
select eid, count(mid) as p_num
from GameSession natural join Participant
group by eid;

create or replace view GameSession_each_event as
select eid, count(gsid) as gs_num
from GameSession
group by eid;

select b.eid, name, COALESCE(a.p_num / a.gs_num, 0) AS average
from (Participant_each_event natural join GameSession_each_event) a
right join Event b on a.eid = b.eid;