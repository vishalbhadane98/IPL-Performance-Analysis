## **SQL Queries**

### 1. Batting vs Fielding First Performance
```sql
WITH match_roles AS (
SELECT
season,
winner,
CASE WHEN toss_decision = 'bat' THEN toss_winner ELSE team1 END AS batting_first_team,
CASE WHEN toss_decision = 'field' THEN toss_winner ELSE team2 END AS fielding_first_team
FROM matches
)
SELECT
team,
COUNT(CASE WHEN winner = batting_first_team THEN 1 END) AS batting_first_wins,
COUNT(CASE WHEN winner = fielding_first_team THEN 1 END) AS fielding_first_wins,
COUNT(*) AS total_matches
FROM (
SELECT season, winner, batting_first_team AS team FROM match_roles
UNION ALL
SELECT season, winner, fielding_first_team AS team FROM match_roles
) AS team_performance
GROUP BY team
ORDER BY total_matches DESC;
```
---

### 2. Toss Decision Impact
```sql
SELECT
toss_decision,
COUNT() AS total_matches,
ROUND(100.0 * SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) / COUNT(), 2) AS win_pct,
AVG(win_by_runs) AS avg_win_margin_runs,
AVG(win_by_wickets) AS avg_win_margin_wickets
FROM matches
GROUP BY toss_decision;
```
---

### 3. Venue Analysis with Match Types
```sql
SELECT
venue,
COUNT() AS total_matches,
ROUND(100.0 * SUM(CASE WHEN win_by_runs > 0 THEN 1 END)/COUNT(),2) AS bat_first_win_pct,
ROUND(100.0 * SUM(CASE WHEN win_by_wickets > 0 THEN 1 END)/COUNT(*),2) AS field_first_win_pct,
COUNT(DISTINCT season) AS seasons_hosted
FROM matches
GROUP BY venue
ORDER BY total_matches DESC
LIMIT 10;

```

---

### 4. Player Performance Analysis
```sql
SELECT
player_of_match AS player,
COUNT(*) AS mom_awards,
SUM(CASE WHEN winner = team1 THEN 1 ELSE 0 END) AS team1_wins,
SUM(CASE WHEN winner = team2 THEN 1 ELSE 0 END) AS team2_wins
FROM matches
GROUP BY player_of_match
ORDER BY mom_awards DESC
LIMIT 10;
```
---

### 5. Championship Analysis with Final Matches
```sql

WITH finals AS (
SELECT
season,
winner,
ROW_NUMBER() OVER (PARTITION BY season ORDER BY date DESC) AS final_match_rank
FROM matches
)
SELECT
winner AS champion_team,
COUNT(*) AS titles_won,
GROUP_CONCAT(season ORDER BY season ASC) AS winning_seasons
FROM finals
WHERE final_match_rank = 1
GROUP BY winner;
```
---
