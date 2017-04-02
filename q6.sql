USE `lahman2016`;

SELECT DISTINCT C.schoolID
FROM CollegePlaying C, Master M
WHERE
    M.playerID = C.playerID AND
    M.debut BETWEEN '2000-05-01' AND DATE_ADD('2000-05-01', INTERVAL 9 DAY);