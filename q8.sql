USE `lahman2016`;

SELECT
    S.yearID, S.salary, M.nameFirst, M.nameLast
FROM
    Master M, (
        SELECT T.yearID , T.salary , T.playerID
        FROM Salaries T, (
                SELECT T2.yearID, MAX(T2.salary) as max_sal
                FROM Salaries T2
                GROUP BY T2.yearID
            ) as T2
        WHERE
            T.yearID = T2.yearID AND
            T.salary = T2.max_sal
    ) as S
WHERE
    M.playerID = S.playerID
ORDER BY
    S.yearID ASC;