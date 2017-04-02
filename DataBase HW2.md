DataBase HW2
=====

## Environment
MySQL 5.7.17 with MySQL Workbench 6.3.9 CE

## 前置作業（方便以下的Query使用，避免sql太長）
- 建 2 個 View: MaxSalaries, WSWinnerTeam

- MaxSalaries
    - 儲存每年每隊的最高薪球員的playerID
    - columns: (yearID, teamID, lgID, playerID, salary)

- WSWinnerTeam
    - 儲存每年的世界大賽冠軍球隊，紀錄時間從西元1985～2004年
    - columns: (yearID, lgID, teamID, franchID)

- view sql檔案: https://github.com/jay16213/Database-practice/blob/master/view.sql
## Query
1. How many plays are recorded in the database?（總共有多少球員被記錄在這個資料庫裡？）
```sql
SELECT COUNT(*)
FROM Master;
```
- result: 19105

---

2. How many countries do the players come from?（這些球員分別來自多少國家？）
```sql
SELECT count(distinct M.birthCountry)
FROM Master M;
```
- result: 54

---

3. List yearID and playerID who hit the home run between 50 and 60. （列出全壘打在50到60之間的球員和年份）
```sql
SELECT B.yearID, B.playerID
FROM Batting B
WHERE B.HR BETWEEN 50 AND 60;
```

- result: [點此github連結](https://github.com/jay16213/Database-practice/blob/master/q3.csv)
---

4. How many parks whose name contains ‘Stadium’ are recorded?（球場名稱中有「Stadium」這個字的球場有幾個？）
```sql
SELECT COUNT(*)
FROM Parks P
WHERE P.`park.name` LIKE '%Stadium%';
```

- result: 29

---

5. How long is the player’s career?（球員生涯大約都幾年？）
```sql
SELECT AVG(M.finalGame - M.debut)
FROM Master M;
```
- result: about 4.67 years

---
6. Find the players’ schools who made their debut at May 2000.（在2000年5月初登場的球員分別在哪些學校打過球？）
```sql
SELECT DISTINCT C.schoolID
FROM CollegePlaying C, Master M
WHERE
    M.playerID = C.playerID AND
    M.debut BETWEEN '2000-05-01' AND DATE_ADD('2000-05-01', INTERVAL 9 DAY);
```

- result
    - camoorp
    - calstfull

---

7. How much is the highest and average salary in each year?（每年平均與最高薪的薪水是多少？）
- 平均薪水
```sql
SELECT
    S.yearID, AVG(S.salary)
FROM
    Salaries S
GROUP BY
    S.yearID;
```

- result: [點此github連結](https://github.com/jay16213/Database-practice/blob/master/q7-avg.csv)

- 最高薪水
```sql
SELECT
    S.yearID, MAX(S.salary)
FROM
    Salaries S
GROUP BY
    S.yearID;
```

- result: [點此github連結](https://github.com/jay16213/Database-practice/blob/master/q7-max.csv)
---

8. In the previous question, who are those highest paid players in each year?（接前一題，這些最高薪球員分別是誰？）
```sql
SELECT
    S.yearID, S.salary, M.nameFirst, M.nameLast
FROM
    Master M, (
        SELECT
            T.yearID , T.salary , T.playerID
        FROM
            Salaries T, (
                SELECT
                    T2.yearID, MAX(T2.salary) as max_sal
                FROM
                    Salaries T2
                GROUP BY
                    T2.yearID
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

- result: [點此github連結](https://github.com/jay16213/Database-practice/blob/master/q8.csv)

9. List the salary and the player that is the highest paid player whose team win the World Series and the highest paid player in Boston Red Sox duaring the Curse of the Bambino.（列出貝比魯斯魔咒期間世界大賽贏家的最高薪球員和當年度波士頓紅襪隊的最高薪球員和他們的年薪）
- 貝比魯斯魔咒: 西元1920 - 2004年
- 但此資料庫沒有西元1984年(含)之前的球員薪資資料
- 因此查詢期間為西元1985 - 2004年
```sql
SELECT
    S.yearID, S.teamID AS WS_winner,
    CONCAT(M.nameFirst, ' ', M.nameLast) AS Name, S.salary,
    CONCAT(M2.nameFirst, ' ', M2.nameLast) AS BOS_Player_Name, S2.salary
from
    WSWinnerTeam W, MaxSalaries S, MaxSalaries S2, Master M, Master M2
where
    W.yearID = S.yearID AND S.yearID = S2.yearID AND
    M.playerID = S.playerID AND
    M2.playerID = S2.playerID AND
    W.teamID = S.teamID AND
    S2.teamID = 'BOS' AND
    S2.yearID BETWEEN 1985 AND 2004
ORDER BY
    S.yearID;
```

- result: [點此github連結](https://github.com/jay16213/Database-practice/blob/master/q9.csv)

---

10. Why Ichiro Suzuki is a good player? Answer by your own view.（鈴木一朗為什麼是好球員？此為開放式問題，列出你的觀察）
- 為求公平，本題在大聯盟出賽平均只計當年度出賽超過81場之選手出賽數，打擊數據平均只計當季打數超過486個的打者的數據(162場x每場平均3打數)

1. 出賽穩定無傷痛
鈴木一朗的每季平均出賽數皆超過MLB每季平均20-30場，生涯16年平均出賽數約為147.1場
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

- result: [點此github連結](https://github.com/jay16213/Database-practice/blob/master/q10-game_played.csv)

2. 打擊成績出色
- 2001 - 2010連續10年打擊率超過3成
- 2001 - 2010連續10年單季安打數超過200支
- 大聯盟單季最多安打數紀錄保持人(2004年單季262支)，至今無人能破
- 歷年三振數為平均的1/2 - 2/3之間，顯示其選球能力及與投手纏鬥之能力
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

- result: [點此github連結](https://github.com/jay16213/Database-practice/blob/master/q10-batting.csv)

---

11. Bonus. Find some meaningful, useful or interesting fact about this data andexplain your result.（找一個有趣的問題回答並解釋）