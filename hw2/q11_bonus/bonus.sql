USE `lahman2016`;
  
/*select the lowest salaries & the highest salaries along WS winner teams*/
(
SELECT
    Ws.yearID, Ws.teamID, Ws.franchID, Ws.total_sal
FROM
    TeamSalaries Ws, (
        SELECT
            MIN(T.total_sal) as MIN_team_sal
        FROM
            WSWinnerTeam W, TeamSalaries T
        WHERE
            W.yearID = T.yearID AND
            W.teamID = T.teamID
    ) AS Temp
WHERE
    Ws.total_sal = Temp.MIN_team_sal
)
UNION
(
SELECT
    Ws.yearID, Ws.teamID, Ws.franchID, Ws.total_sal
FROM
    TeamSalaries Ws, (
        SELECT
            MAX(T.total_sal) as MAX_team_sal
        FROM
            WSWinnerTeam W, TeamSalaries T
        WHERE
            W.yearID = T.yearID AND
            W.teamID = T.teamID
    ) AS Temp
WHERE
    Ws.total_sal = Temp.MAX_team_sal
);