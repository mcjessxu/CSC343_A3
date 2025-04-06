create or replace view ptcp_times as
select mid, count(gsid) as times
from Participant
group by mid;

select * from Member natural join (
select mid, times from ptcp_times
where times = (select max(times) from ptcp_times)) a;