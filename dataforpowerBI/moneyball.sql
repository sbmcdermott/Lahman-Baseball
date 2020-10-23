--Number of wins and team salary for all teams in 2002
SELECT DISTINCT s.teamid, s.lgid, t.w,
	SUM(salary::numeric::money) OVER (PARTITION BY s.teamid) AS teamsalary
FROM salaries AS s
LEFT JOIN people AS p ON s.teamid = p.playerid
LEFT JOIN teams AS t ON t.teamid = s.teamid
WHERE s.yearid = 2002 AND t.yearid = 2002
GROUP BY s.teamid, s.lgid, s.salary, t.w
ORDER BY teamsalary;

--All of the years that OAK went to the world series with Billy Beane as GM
SELECT * 
FROM seriespost
WHERE yearid > 1996
AND (teamidwinner = 'OAK' OR teamidloser = 'OAK');

--OAK = Oakland A's franchid
SELECT * 
FROM teamsfranchises;

--Team data for OAK when Beane was manager
SELECT * 
FROM teams
WHERE yearid BETWEEN 1996 AND 2015
AND teamid = 'OAK';

--2002 team data, 103 wins (2nd), 
SELECT *
FROM teams
WHERE yearid = 2002
ORDER BY w DESC;


--OAK's team salary when Beane was manager
SELECT yearid, SUM(salary)::numeric::money 
FROM salaries
WHERE teamid = 'OAK' AND yearid BETWEEN 1997 AND 2015
GROUP BY yearid
ORDER BY yearid;


--Chadwick Lee Bradford
SELECT * 
FROM pitchingpost as pp
LEFT JOIN people AS p ON pp.playerid = p.playerid
WHERE yearid = 2002
ORDER BY baopp;

--before and null = 10471, before 27565, after and null = 1822, after 21182
WITH hs_after AS (SELECT count(*) 
FROM people AS p
LEFT JOIN collegeplaying AS c ON c.playerid = p.playerid
WHERE schoolid IS NULL
AND date_part('year', debut::date) > 2003),

hs_before AS (SELECT count(*) 
FROM people AS p
LEFT JOIN collegeplaying AS c ON c.playerid = p.playerid
WHERE schoolid IS NULL
AND date_part('year', debut::date) < 2003),

c_after AS (SELECT count(*) 
FROM people AS p
LEFT JOIN collegeplaying AS c ON c.playerid = p.playerid
AND date_part('year', debut::date) > 2003),

c_before AS (SELECT count(*) 
FROM people AS p
LEFT JOIN collegeplaying AS c ON c.playerid = p.playerid
AND date_part('year', debut::date) < 2003)

SELECT count AS hs_before
FROM hs_before
UNION
SELECT count AS c_before
FROM c_before;

SELECT * 
FROM people AS p
LEFT JOIN collegeplaying AS c ON c.playerid = p.playerid
LEFT JOIN teams
where C.schoolid IS NULL;

WITH college AS 
	(SELECT DISTINCT a.playerid, a.yearid, a.teamid, 
		CASE WHEN c.schoolid IS NOT NULL THEN 1
			 WHEN c.schoolid IS NULL THEN 0
		END AS college
	FROM appearances AS a
	LEFT JOIN collegeplaying AS c ON c.playerid = a.playerid
	WHERE a.teamid = 'OAK'
	ORDER BY a.yearid)
	
SELECT yearid, teamid, SUM(college) AS college_educated, count(*) AS players, (SUM(college)::float/COUNT(*)::float) AS percent_college
FROM college
GROUP BY yearid, teamid
ORDER BY yearid;


SELECT yearid, teamid, SUM(so) AS strikeouts, SUM(h) AS hits
FROM teams
WHERE yearid > 1990 AND teamid = 'OAK'
GROUP BY yearid, teamid
ORDER BY yearid;