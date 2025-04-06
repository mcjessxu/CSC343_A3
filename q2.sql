select tc.gcopy_id, tc.game_id, COALESCE(played_time, 0) as played_time
from TrackCopies tc left join
(select gcopy_id, count(gsid) as played_time 
from UsedCopy
group by gcopy_id) a on a.gcopy_id = tc.gcopy_id;