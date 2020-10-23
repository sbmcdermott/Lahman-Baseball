--#5 PART A average strikeouts per game over decades
--First CTE to get yearly strikeouts
WITH yearly_so AS 
	(SELECT DISTINCT(yearid),
	SUM(so) OVER(PARTITION BY yearid) as so_year,
	CASE WHEN yearid BETWEEN 1920 AND 1929 THEN 1920
	 WHEN yearid BETWEEN 1930 AND 1939 THEN 1930
	 WHEN yearid BETWEEN 1940 AND 1949 THEN 1940
	 WHEN yearid BETWEEN 1950 AND 1959 THEN 1950
	 WHEN yearid BETWEEN 1960 AND 1969 THEN 1960
	 WHEN yearid BETWEEN 1970 AND 1979 THEN 1970
	 WHEN yearid BETWEEN 1980 AND 1989 THEN 1980
	 WHEN yearid BETWEEN 1990 AND 1999 THEN 1990
	 WHEN yearid BETWEEN 2000 AND 2009 THEN 2000
	 WHEN yearid BETWEEN 2010 AND 2016 THEN 2010
	END AS decade
	FROM batting
	WHERE yearid > 1920
	ORDER BY yearid),
--Second CTE to get yearly games
yearly_g AS 
	(SELECT DISTINCT(year),
	SUM(games) OVER(PARTITION BY year) as g_year,
	CASE WHEN year BETWEEN 1920 AND 1929 THEN 1920
	 WHEN year BETWEEN 1930 AND 1939 THEN 1930
	 WHEN year BETWEEN 1940 AND 1949 THEN 1940
	 WHEN year BETWEEN 1950 AND 1959 THEN 1950
	 WHEN year BETWEEN 1960 AND 1969 THEN 1960
	 WHEN year BETWEEN 1970 AND 1979 THEN 1970
	 WHEN year BETWEEN 1980 AND 1989 THEN 1980
	 WHEN year BETWEEN 1990 AND 1999 THEN 1990
	 WHEN year BETWEEN 2000 AND 2009 THEN 2000
	 WHEN year BETWEEN 2010 AND 2016 THEN 2010
	END AS decade
	FROM homegames
	WHERE year > 1920
	ORDER BY year)
--Select and inner join CTEs to get the decade and avg strike outs per game
SELECT DISTINCT(yearly_so.decade),
	   ROUND(SUM(so_year) OVER(PARTITION BY yearly_so.decade)/ 
	   SUM(g_year) OVER(PARTITION BY yearly_g.decade),2) AS so_per_g_decade
FROM yearly_so INNER JOIN yearly_g
ON yearly_so.yearid = yearly_g.year
GROUP BY yearly_so.yearid, yearly_so.so_year, yearly_g.g_year, yearly_so.decade, yearly_g.decade
ORDER BY yearly_so.decade;

--PART B average homeruns per game over decades
--First CTE to get yearly strikeouts
WITH yearly_h AS 
	(SELECT DISTINCT(yearid),
	SUM(hr) OVER(PARTITION BY yearid) as h_year,
	CASE WHEN yearid BETWEEN 1920 AND 1929 THEN 1920
	 WHEN yearid BETWEEN 1930 AND 1939 THEN 1930
	 WHEN yearid BETWEEN 1940 AND 1949 THEN 1940
	 WHEN yearid BETWEEN 1950 AND 1959 THEN 1950
	 WHEN yearid BETWEEN 1960 AND 1969 THEN 1960
	 WHEN yearid BETWEEN 1970 AND 1979 THEN 1970
	 WHEN yearid BETWEEN 1980 AND 1989 THEN 1980
	 WHEN yearid BETWEEN 1990 AND 1999 THEN 1990
	 WHEN yearid BETWEEN 2000 AND 2009 THEN 2000
	 WHEN yearid BETWEEN 2010 AND 2016 THEN 2010
	END AS decade
	FROM batting
	WHERE yearid > 1920
	ORDER BY yearid),
--Second CTE to get yearly games
yearly_g AS 
	(SELECT DISTINCT(year),
	SUM(games) OVER(PARTITION BY year) as g_year,
	CASE WHEN year BETWEEN 1920 AND 1929 THEN 1920
	 WHEN year BETWEEN 1930 AND 1939 THEN 1930
	 WHEN year BETWEEN 1940 AND 1949 THEN 1940
	 WHEN year BETWEEN 1950 AND 1959 THEN 1950
	 WHEN year BETWEEN 1960 AND 1969 THEN 1960
	 WHEN year BETWEEN 1970 AND 1979 THEN 1970
	 WHEN year BETWEEN 1980 AND 1989 THEN 1980
	 WHEN year BETWEEN 1990 AND 1999 THEN 1990
	 WHEN year BETWEEN 2000 AND 2009 THEN 2000
	 WHEN year BETWEEN 2010 AND 2016 THEN 2010
	END AS decade
	FROM homegames
	WHERE year > 1920
	ORDER BY year)
--Select and inner join CTEs to get the decade and avg strike outs per game
SELECT DISTINCT(yearly_h.decade),
	   ROUND(SUM(h_year) OVER(PARTITION BY yearly_h.decade)/ 
	   SUM(g_year) OVER(PARTITION BY yearly_g.decade),2) AS h_per_g_decade
FROM yearly_h INNER JOIN yearly_g
ON yearly_h.yearid = yearly_g.year
GROUP BY yearly_h.yearid, yearly_h.h_year, yearly_g.g_year, yearly_h.decade, yearly_g.decade
ORDER BY yearly_h.decade;


--#9 leyland, johnson
WITH fullname_nl AS(
	SELECT CONCAT(p.namefirst, ' ',p.namelast) AS fullname, 
	   t.name,
	   am.awardid, am.lgid as NL, am.yearid, m.teamid,
	   COUNT(am.lgid) OVER (PARTITION BY CONCAT(p.namefirst, ' ', p.namelast), am.lgid) AS award_count
FROM awardsmanagers AS am 
INNER JOIN people AS p 
	ON  am.playerid = p.playerid 
INNER JOIN managers AS m
	ON am.playerid = m.playerid AND am.yearid = m.yearid
LEFT JOIN teams AS t
	ON m.teamid = t.teamid AND m.yearid = t.yearid
WHERE am.awardid LIKE '%TSN%' 
AND (am.lgid = 'NL')
GROUP BY p.namefirst, p.namelast, am.awardid, am.lgid, m.teamid, t.name, am.yearid
ORDER BY CONCAT(p.namefirst, ' ',p.namelast)),

fullname_al AS(
	SELECT CONCAT(p.namefirst, ' ',p.namelast) AS fullname, 
	   t.name,
	   am.awardid, am.lgid AS AL, am.yearid, m.teamid,
	   COUNT(am.lgid) OVER (PARTITION BY CONCAT(p.namefirst, ' ', p.namelast), am.lgid) AS award_count
FROM awardsmanagers AS am 
INNER JOIN people AS p 
	ON  am.playerid = p.playerid 
INNER JOIN managers AS m
	ON am.playerid = m.playerid AND am.yearid = m.yearid
LEFT JOIN teams AS t
	ON m.teamid = t.teamid AND m.yearid = t.yearid
WHERE am.awardid LIKE '%TSN%' 
AND (am.lgid = 'AL')
GROUP BY p.namefirst, p.namelast, am.awardid, am.lgid, m.teamid, t.name, am.yearid
ORDER BY CONCAT(p.namefirst, ' ',p.namelast))


SELECT DISTINCT nl.fullname, nl.name, al.name
FROM fullname_nl as nl INNER JOIN fullname_al as al
ON nl.fullname = al.fullname;

/*
--#8 CHECK

SELECT DISTINCT p.park_name, h.team,
	(h.attendance/h.games) as avg_attendance, t.name		
FROM homegames as h JOIN parks as p ON h.park = p.park
LEFT JOIN teams as t on h.team = t.teamid AND t.yearid = h.year
WHERE year = 2016
AND games >= 10
ORDER BY avg_attendance DESC
LIMIT 5;

--#6 CHECK 
SELECT Concat(namefirst,' ',namelast), batting.yearid, ROUND(MAX(sb::decimal/(cs::decimal+sb::decimal))*100,2) as sb_success_percentage
FROM batting
INNER JOIN people on batting.playerid = people.playerid
WHERE yearid = '2016'
AND (sb+cs) >= 20
GROUP BY namefirst, namelast, batting.yearid
ORDER BY sb_success_percentage DESC; --Chris Owings with a %91.3 success rate

*/


--#13 Part A 20% of pitchers throw left handed
WITH right_throw AS(
SELECT DISTINCT playerid, throws
FROM people
WHERE throws = 'R'),

left_throw AS(
SELECT DISTINCT playerid, throws
FROM people
WHERE throws = 'L')

SELECT
	   ((COUNT(l.throws)::FLOAT) /
	   ((COUNT(r.throws)::FLOAT)+(COUNT(l.throws)::FLOAT))) * 100 AS left_pitcher_percentage
FROM right_throw AS r
FULL JOIN left_throw AS l
ON r.playerid = l.playerid;

--#13 Part B Are left-handed pitchers more likely to win the Cy Young Award? 
--33% of Cy Young recipients are left handed, compared to only 20% of all pitchers 
WITH right_throw AS(
SELECT DISTINCT playerid, throws
FROM people
WHERE throws = 'R'),

left_throw AS(
SELECT DISTINCT playerid, throws
FROM people
WHERE throws = 'L')

SELECT 
		((COUNT(l.throws)::FLOAT)/
		(COUNT(r.throws)::FLOAT + COUNT(l.throws)::FLOAT)) * 100 AS left_awards_percentage
FROM awardsplayers AS ap
LEFT JOIN left_throw AS l
	ON l.playerid = ap.playerid
LEFT JOIN right_throw AS r
	ON r.playerid = ap.playerid
WHERE awardid ILIKE '%young%';

--#13 Part C Are they more likely to make it into the hall of fame? 
--18% of hall of fame inductees are left handed pitchers, compared to 20% of 
WITH all_throw AS(
WITH right_throw AS(
SELECT DISTINCT playerid AS rplayerid, throws AS rthrows
FROM people
WHERE throws = 'R'),

left_throw AS(
SELECT DISTINCT playerid AS lplayerid, throws AS lthrows 
FROM people
WHERE throws = 'L')

SELECT r.rplayerid, r.rthrows, l.lplayerid, l.lthrows 
FROM right_throw AS r
FULL JOIN left_throw AS l
	ON r.rplayerid = l.lplayerid)

SELECT 
		((COUNT(at.Lthrows)::FLOAT) / 
		(COUNT(rthrows)::FLOAT + COUNT(lthrows)::FLOAT)) * 100 AS left_halloffame_percentage
FROM all_throw AS at
LEFT JOIN halloffame AS hf
	ON at.rplayerid = hf.playerid
LEFT JOIN halloffame AS hf2
	ON at.lplayerid = hf2.playerid
WHERE hf.inducted = 'Y' OR hf2.inducted = 'Y';

/* MAHESH CHECK
WITH pitchers AS (SELECT *
				  FROM people INNER JOIN pitching USING(playerid)
				 	   INNER JOIN awardsplayers USING(playerid)
				 	   INNER JOIN halloffame USING(playerid))
SELECT (SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE throws = 'L')/COUNT(DISTINCT playerid)::float AS pct_left_pitch,
	   (SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE awardid = 'Cy Young Award')/COUNT(DISTINCT playerid)::float AS pct_cy_young,
	   ((SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE awardid = 'Cy Young Award')/COUNT(DISTINCT playerid)::float) * ((SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE throws = 'L')/COUNT(DISTINCT playerid)::float) AS calc_pct_left_cy_young,
	   (SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE awardid = 'Cy Young Award' AND throws = 'L')/COUNT(DISTINCT playerid)::float AS actual_pct_left_cy_young,
	   (SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE inducted = 'Y')/COUNT(DISTINCT playerid)::float AS pct_hof,
	   ((SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE inducted = 'Y')/COUNT(DISTINCT playerid)::float) * ((SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE throws = 'L')/COUNT(DISTINCT playerid)::float) AS calc_pct_left_hof,
	   (SELECT COUNT(DISTINCT playerid)::float FROM pitchers WHERE inducted = 'Y' AND throws = 'L')/COUNT(DISTINCT playerid)::float AS actual_pct_left_hof
FROM pitchers;
*/