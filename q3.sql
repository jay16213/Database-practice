use `lahman2016`;

select
    B.yearID, M.nameFirst, M.nameLast
from
    Batting B, Master M
where
    B.playerID = M.playerID and
    B.HR between 50 and 60
order by
    B.yearID asc;
    