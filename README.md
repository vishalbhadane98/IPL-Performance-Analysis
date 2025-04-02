# **IPL Performance Analysis  (2008–2024)**

## **Overview**

Welcome to the **IPL Performance Analysis** project! This repository provides a detailed analysis of IPL matches from 2008 to 2024 using SQL. The project leverages advanced SQL techniques to uncover trends in team strategies, player performances, venue-specific dynamics, and championship outcomes. The findings of project can be accessed through the dashboard shown below
---
![Dashboard](https://github.com/vishalbhadane98/IPL-Performance-Analysis/blob/main/Screenshot%202025-03-31%20152535.png)
---
## **Table of Contents**

1. [Project Objectives](#project-objectives)  
2. [Technologies Used](#technologies-used)  
3. [Dataset Description](#dataset-description)  
4. [Enhanced SQL Queries](#enhanced-sql-queries)  
   - Batting vs Fielding First Performance  
   - Toss Decision Impact  
   - Venue Analysis with Match Types  
   - Player Performance Analysis  
   - Championship Analysis with Final Matches  
5. [How to Use This Project](#how-to-use-this-project)  
6. [Project Status](#project-status)  
7. [Contributing](#contributing)  
8. [License](#license)

---

## **Project Objectives**

This project aims to analyze IPL match data to uncover valuable insights:

1. **Batting vs Fielding First Performance**: Analyze team performance based on whether they bat or field first.
2. **Toss Decision Impact**: Evaluate how toss decisions influence match outcomes.
3. **Top Venues Analysis**: Identify venues with the most matches and analyze win rates based on batting or fielding first.
4. **Player Performance Analysis**: Highlight players with the most "Man of the Match" awards.
5. **Championship Analysis**: Track teams that have won IPL titles across seasons.

---

## **Technologies Used**

- **SQL**: Advanced queries using joins, window functions, subqueries, and aggregations.
- **Kaggle Dataset**: IPL ball-by-ball data (`matches.csv`, `deliveries.csv`).
- **Markdown**: For README documentation.
- **GitHub**: Repository hosting and version control.

---

## **Dataset Description**

### Matches Table
| Column Name         | Description                       |
|---------------------|-----------------------------------|
| `id`                | Match ID                         |
| `season`            | IPL season year                  |
| `city`              | City where the match was played  |
| `date`              | Match date                       |
| `team1`, `team2`    | Competing teams                  |
| `toss_winner`       | Team that won the toss           |
| `toss_decision`     | Toss decision (bat/field)        |
| `result`            | Match result type (normal/tie)   |
| `winner`            | Winning team                    |
| `win_by_runs`, `win_by_wickets` | Margin of victory    |
| `player_of_match`   | Player awarded "Man of the Match"|
| `venue`             | Venue name                      |

---

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


## **Project Status**
✅ Completed — Ready for use and further enhancements.

---

## **Contributing**
Feel free to fork this repository and submit pull requests for additional analyses or optimizations!

---

## **License**
This project is licensed under the MIT License.

---
