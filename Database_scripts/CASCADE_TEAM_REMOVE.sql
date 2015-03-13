/* !APPLY CHANGES TO THE DATABASE - START */
DECLARE @teamname NVARCHAR(MAX);
SET @teamname = 'Brainstorm';

ALTER TABLE Player
DROP CONSTRAINT  FK_Player_Team

ALTER TABLE Player
ADD CONSTRAINT FK_Player_Team FOREIGN KEY (team_id)
		REFERENCES Team(id) ON DELETE CASCADE

---

ALTER TABLE Answer
DROP CONSTRAINT  FK_Answer_Team

ALTER TABLE Answer
ADD CONSTRAINT FK_Answer_Team FOREIGN KEY (team_id)
		REFERENCES Team(id) ON DELETE CASCADE

--

ALTER TABLE TeamTournament
DROP CONSTRAINT  FK_TeamTournament_Team

ALTER TABLE TeamTournament
ADD CONSTRAINT FK_TeamTournament_Team FOREIGN KEY (team_id)
		REFERENCES Team(id) ON DELETE CASCADE
--

ALTER TABLE PlayerSeason
DROP CONSTRAINT  FK_PlayerSeason_Player

ALTER TABLE PlayerSeason
ADD CONSTRAINT FK_PlayerSeason_Player FOREIGN KEY (player_id)
		REFERENCES Player(id) ON DELETE CASCADE
--
/* .APPLY CHANGES TO THE DATABASE - FINISH */


/* !OUTPUT - START */
SELECT *
FROM Player, Team, TeamTournament, Answer
WHERE Player.team_id = Team.id AND Team.name = @teamname AND
		TeamTournament.team_id = Team.id AND
		Answer.team_id = Team.id
/* .OUTPUT - FINISH */

/* !REMOVE TEAM - START */
DELETE FROM Team
WHERE Team.name = @teamname
/* .REMOVE TEAM - FINISH */

/* !OUTPUT - START */
SELECT *
FROM Player, Team, TeamTournament, Answer
WHERE Player.team_id = Team.id AND Team.name = @teamname AND
		TeamTournament.team_id = Team.id AND
		Answer.team_id = Team.id
/* !OUTPUT - FINISH */