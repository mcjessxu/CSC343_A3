create or replace view fclt_times as
select game, facilitator, count(gsid) as times
from GameSession
group by game, facilitator;

select game from fclt_times
where times = (select max(times) from fclt_times);