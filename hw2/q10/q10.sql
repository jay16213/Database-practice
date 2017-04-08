USE `lahman2016`;

SELECT
    B.yearID,
    AVG(B.H) AS Avg_H, Suz.H AS Suz_H,
    AVG(B.SO) AS Avg_SO, Suz.SO AS Suz_SO,
    Suz.A AS Suz_Avg
FROM
    Batting B, (
        SELECT
            B2.yearID,
            SUM(B2.H) AS H,
            SUM(B2.SO) AS SO,
            SUM(B2.H)/SUM(B2.AB) AS A
        FROM
            Batting B2
        WHERE
            B2.playerID = 'suzukic01'
        GROUP BY
            B2.yearID
    ) AS Suz
WHERE
    B.yearID = Suz.yearID AND
    B.ab >= 486
GROUP BY
    B.yearID;
    
SELECT
    B.yearID, AVG(B.G) AS Suz_G, AVG(B2.G) AS Avg_G
FROM
    Batting B, Batting B2
WHERE
    B.playerID = 'suzukic01' AND
    B.yearID = B2.yearID AND
    B2.G >= 81
GROUP BY
    B.yearID;
