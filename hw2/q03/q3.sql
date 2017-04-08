use `lahman2016`;

select
    B.yearID, B.playerID
from
    Batting B
where
    B.HR between 50 and 60;
    