USE `lahman2016`;

SELECT
    S.yearID, AVG(S.salary)
FROM
    Salaries S
GROUP BY
    S.yearID;
    
SELECT
    S.yearID, MAX(S.salary)
FROM
    Salaries S
GROUP BY
    S.yearID;