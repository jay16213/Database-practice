DataBase HW2
=====
#### 0416213 林彥傑

- 所有sql, result的csv格式可至[此github連結](https://github.com/jay16213/Database-practice)

## Environment
MySQL 5.7.17 with MySQL Workbench 6.3.9 CE

## 前置作業(方便以下的Query使用 , 避免sql太長)
- 建 3 個 View : MaxSalaries, TeamSalaries, WSWinnerTeam

- MaxSalaries
    - 儲存每年每隊的最高薪球員的playerID
    
    - columns : (yearID, teamID, lgID, playerID, salary)

```sql
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
```

- TeamSalaries
    - 儲存大聯盟歷年各隊的團隊薪資總和

    - columns : (yearID, lgID, teamID, franchID, total_sal)

```sql
CREATE VIEW `TeamSalaries` AS(
    SELECT
        T.yearID, T.lgID, T.teamID, T.franchID, S.total_sal
    FROM
        Teams T, (
            SELECT t.yearID, t.teamID, sum(t.salary) AS total_sal
            FROM Salaries t
            GROUP BY t.yearID, t.teamID
        ) AS S
    WHERE
        T.yearID = S.yearID AND
        T.teamID = S.teamID
);
```

- WSWinnerTeam
    - 儲存每年的世界大賽冠軍球隊

    - columns : (yearID, lgID, teamID, franchID)

```sql
create view `WSWinnerTeam` as(
    select
        T.yearID, T.lgID, T.teamID, T.franchID
    from
        Teams T
    where
        T.WSWin = 'Y'
);
```

- [view sql檔案](https://github.com/jay16213/Database-practice/blob/master/view.sql)

## Query

#### Q1: How many players are recorded in the database ?
```sql
SELECT COUNT(*)
FROM Master;
```

- result : 19105  

#### Q2: How many countries do the players come from ?
```sql
SELECT count(distinct M.birthCountry)
FROM Master M;
```

- result : 54  

#### Q3: List yearID and playerID who hit the home run between 50 and 60.
```sql
SELECT B.yearID, B.playerID
FROM Batting B
WHERE B.HR BETWEEN 50 AND 60;
```

- result: https://github.com/jay16213/Database-practice/blob/master/q3.csv

#### Q4: How many parks whose name contains ‘Stadium’ are recorded?
```sql
SELECT COUNT(*)
FROM Parks P
WHERE P.`park.name` LIKE '%Stadium%';
```

- result : 29  

#### Q5: How long is the player’s career ?
```sql
SELECT AVG(M.finalGame - M.debut)
FROM Master M;
```

- result : 4.668254383669197  

#### Q6: Find the players’ schools who made their debut at May 2000.
```sql
SELECT DISTINCT C.schoolID
FROM CollegePlaying C, Master M
WHERE
    M.playerID = C.playerID AND
    M.debut BETWEEN '2000-05-01' AND '2000-05-31';
```

- result : https://github.com/jay16213/Database-practice/blob/master/q6.csv

#### Q7: How much is the highest and average salary in each year ?

- 平均薪水
```sql
SELECT
    S.yearID, AVG(S.salary)
FROM
    Salaries S
GROUP BY
    S.yearID;
```

- result: https://github.com/jay16213/Database-practice/blob/master/q7-avg.csv

- 最高薪水
```sql
SELECT
    S.yearID, MAX(S.salary)
FROM
    Salaries S
GROUP BY
    S.yearID;
```

- result: https://github.com/jay16213/Database-practice/blob/master/q7-max.csv

#### Q8: In the previous question, who are those highest paid players in each year ?
```sql
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
```

- result: https://github.com/jay16213/Database-practice/blob/master/q8.csv

#### Q9: List the salary and the player that is the highest paid player whose team win the World Series and the highest paid player in Boston Red Sox duaring the Curse of the Bambino.

- 貝比魯斯魔咒: 西元1920 - 2004年

- 但此資料庫沒有西元1984年(含)之前的球員薪資資料

- 因此查詢期間為西元1985 - 2004年

```sql
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
```

- result: https://github.com/jay16213/Database-practice/blob/master/q9.csv

#### Q10: Why Ichiro Suzuki is a good player? Answer by your own view.

- 為求公平, 本題在大聯盟出賽平均只計當年度出賽超過81場之選手出賽數, 打擊數據平均只計當季打數超過486個的打者的數據(162場 x 每場平均3打數)

- 出賽穩定無傷痛

    - 鈴木一朗每季出賽數皆超過MLB每季平均20-30場 , 生涯16年平均出賽數約為147.1場

```sql
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
```

- result: https://github.com/jay16213/Database-practice/blob/master/q10-game_played.csv

- 打擊成績出色

    - 2001 - 2010連續10年打擊率超過3成

    - 2001 - 2010連續10年單季安打數超過200支

    - 大聯盟單季最多安打數紀錄保持人(2004年單季262支) , 至今無人能破

    - 歷年單季總三振數為平均的1/2 - 2/3之間 , 顯示其選球能力及與投手纏鬥之能力

```sql
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
            SUM(B2.H)/SUM(B2.AB) AS A,
            SUM(B2.SO) AS SO
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
```

- result: https://github.com/jay16213/Database-practice/blob/master/q10-batting.csv

#### Bonus: 找出歷年來團隊薪資最便宜 ＆ 最貴的世界大賽冠軍球隊
```sql
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
```

- result : https://github.com/jay16213/Database-practice/blob/master/bonus.csv

<table style="border-collapse: collapse">
    <tr>
        <td>yearID</td><td>teamID</td><td>franchID</td><td>total_sal</td>
    </tr>
    <tr>
        <td>1987</td><td>MIN</td><td>MIN</td><td>6397500</td>
    </tr>
    <tr>
        <td>2009</td><td>NYA</td><td>NYY</td><td>201449189</td>
    </tr>
</table>

- 若不考慮通貨膨脹等問題 , 則由上述結果可知 , 1987年的馬林魚僅花費約640萬美金就贏得當年的世界大賽冠軍 , 2009年的洋基隊則花了2億多美金才贏得冠軍 , 是有薪資紀錄以來最豪華的奪冠球隊

- 查詢MaxSalaries , 可知2009年洋基隊年薪最高的A-ROD當年年薪為3300萬美金，是640萬美金的5倍有餘
