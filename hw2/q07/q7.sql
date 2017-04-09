USE `lahman2016`;

SELECT
    S.yearID, AVG(S.salary), MAX(S.salary)
FROM
    Salaries S
GROUP BY
    S.yearID;