create or replace view fclt_times as
select game_id, facilitator, count(gsid) as times
from GameSession
group by game_id, facilitator;

select * from BoardGame natural join
(select game_id from fclt_times
where times = (select max(times) from fclt_times)) a;