USE `lahman2016`;

SELECT DISTINCT C.schoolID
FROM CollegePlaying C, Master M
WHERE
    M.playerID = C.playerID AND
    M.debut BETWEEN '2000-05-01' AND '2000-05-31';