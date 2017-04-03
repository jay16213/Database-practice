USE `lahman2016`;

SELECT
    S.yearID, S.teamID AS WS_winner,
    CONCAT(M.nameFirst, ' ', M.nameLast) AS Name, S.salary,
    CONCAT(M2.nameFirst, ' ', M2.nameLast) AS BOS_Player_Name, S2.salary
FROM
    WSWinnerTeam W, MaxSalaries S, MaxSalaries S2, Master M, Master M2
WHERE
    W.yearID = S.yearID AND S.yearID = S2.yearID AND
    M.playerID = S.playerID AND
    M2.playerID = S2.playerID AND
    W.teamID = S.teamID AND
    S2.teamID = 'BOS' AND
    W.yearID BETWEEN 1985 AND 2004
ORDER BY
    S.yearID;