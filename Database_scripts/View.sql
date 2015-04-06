GO
IF OBJECT_ID('GameRound_User', 'V') IS NOT NULL
	DROP VIEW GameRound_User
GO
CREATE VIEW GameRound_User AS
	SELECT GameRound.tournament_id, GameRound.gamenumber, GameRound.id
		FROM GameRound, Users, Tournament
		WHERE Users.name = CURRENT_USER
		AND ((IS_MEMBER('Coordinator') = 1
		AND GameRound.tournament_id = Tournament.id
		AND Tournament.address_id = Users.address_id)
		OR ((IS_MEMBER('Organizer') = 1 OR IS_MEMBER('Jury') = 1 OR IS_MEMBER('AppelJury') = 1)
		AND GameRound.tournament_id = Users.tournament_id))
WITH CHECK OPTION;

GO
IF OBJECT_ID('Tournament_User', 'V') IS NOT NULL
	DROP VIEW Tournament_User
GO
CREATE VIEW Tournament_User AS
	SELECT Tournament.id, Tournament.name, Tournament.address_id, Tournament.password, Tournament.season_id
		FROM Tournament, Users
		WHERE Users.name = CURRENT_USER
		AND ((IS_MEMBER('Coordinator') = 1
		AND Tournament.address_id = Users.address_id)
		OR ((IS_MEMBER('Organizer') = 1 OR IS_MEMBER('Jury') = 1 OR IS_MEMBER('AppelJury') = 1)
		AND Tournament.id = Users.tournament_id))
WITH CHECK OPTION;

GO
IF OBJECT_ID ('TeamTournament_User', 'V') IS NOT NULL
	DROP VIEW TeamTournament_User;
GO
CREATE VIEW TeamTournament_User AS
	SELECT TeamTournament.tournament_id, TeamTournament.team_id, TeamTournament.age_category_id, TeamTournament.regcard_number
		FROM TeamTournament, Users, Tournament
		WHERE Users.name = CURRENT_USER
		AND ((IS_MEMBER('Coordinator') = 1
		AND TeamTournament.tournament_id = Tournament.id
		AND Tournament.address_id = Users.address_id)
		OR ((IS_MEMBER('Organizer') = 1 OR IS_MEMBER('Jury') = 1 OR IS_MEMBER('AppelJury') = 1)
		AND TeamTournament.tournament_id = Users.tournament_id))
WITH CHECK OPTION;
GO

IF OBJECT_ID ('Team_User', 'V') IS NOT NULL
DROP VIEW Team_User;
GO
CREATE VIEW Team_User AS
	SELECT Team.id, Team.name, Team.phone, Team.email, Team.captain_id, Team.address_id
		FROM TeamTournament, Users, Team, Tournament
		WHERE Users.name = CURRENT_USER
		AND ((IS_MEMBER('Coordinator') = 1
		AND TeamTournament.tournament_id = Tournament.id
		AND Tournament.address_id = Users.address_id
		AND TeamTournament.team_id = Team.id)
		OR ((IS_MEMBER('Organizer') = 1 OR IS_MEMBER('Jury') = 1 OR IS_MEMBER('AppelJury') = 1)
		AND TeamTournament.tournament_id = Users.tournament_id
		AND TeamTournament.team_id = Team.id))
WITH CHECK OPTION;
GO

GO
IF OBJECT_ID ('Player_User', 'V') IS NOT NULL
	DROP VIEW Player_User;
GO
CREATE VIEW Player_User AS
	SELECT Player.id, Player.name, Player.birthday, Player.team_id
		FROM PlayerSeason, Player, Users, Tournament
		WHERE Users.name = CURRENT_USER
		AND ((IS_MEMBER('Coordinator') = 1
		AND Tournament.address_id = Users.address_id
		AND Tournament.season_id = PlayerSeason.season_id
		AND PlayerSeason.player_id = Player.id) 
		OR ((IS_MEMBER('Organizer') = 1 OR IS_MEMBER('Jury') = 1 OR IS_MEMBER('AppelJury') = 1)
		AND Tournament.id = Users.tournament_id
		AND Tournament.season_id = PlayerSeason.season_id
		AND PlayerSeason.player_id = Player.id))
WITH CHECK OPTION;
GO

IF OBJECT_ID ('Answer_User', 'V') IS NOT NULL
	DROP VIEW Answer_User;
GO
CREATE VIEW Answer_User AS
	SELECT Answer.id, Answer.answer_text, Answer.gameround_id, Answer.is_valid, Answer.question_id, Answer.question_num, Answer.team_id
		FROM Answer, Users, Tournament, GameRound
		WHERE Users.name = CURRENT_USER
		AND GameRound.tournament_id = Users.tournament_id
		AND GameRound.id = Answer.gameround_id
WITH CHECK OPTION;
GO

IF OBJECT_ID ('Game_Table', 'V') IS NOT NULL
DROP VIEW Game_Table;
GO

CREATE VIEW Game_Table
AS
	SELECT name, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31], [32], [33], [34], [35], [36]
	FROM
	(
		SELECT Answer.id AS id, Team.name, Answer.question_num
		FROM Team
		LEFT JOIN Answer
			ON Team.id = Answer.team_id
		WHERE gameround_id = 2 AND is_valid = 1
	) x
	PIVOT
	(
	COUNT(id)
	FOR question_num IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31], [32], [33], [34], [35], [36])
	) p;
GO

