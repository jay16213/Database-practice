use `lahman2016`;

/*the player who receives the most salaries in every team every year*/
drop view if exists `MaxSalaries`;
create view `MaxSalaries` as (
select
    S.yearID, S.teamID, S.lgID, S.playerID, S.salary
from
    Salaries S, (
        select S2.yearID, S2.teamID, max(S2.salary) as max_sal
        from Salaries S2
        group by S2.yearID, S2.teamID
    ) as temp
where
    S.yearID = temp.yearID and
    S.teamID = temp.teamID and
    S.salary = temp.max_sal
);

/*the team of WS winner, from 1985 to 2004*/
drop view if exists `WSWinnerTeam`;
create view `WSWinnerTeam` as(
    select
        T.yearID, T.lgID, T.teamID, T.franchID
    from
        Teams T
    where
        T.WSWin = 'Y' and T.yearID between 1985 and 2004
);

/*create view WinnerMemberShip as
(
    select
        W.yearID, W.teamID, S.playerID, S.salary
    from
        wswinner W, lahman2016.salaries S
    where
        W.teamID = S.teamID and
        W.yearID = S.yearID
);*/