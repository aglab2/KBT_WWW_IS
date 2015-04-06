GO
IF OBJECT_ID('GameRound_Coordinator', 'V') IS NOT NULL
	DROP VIEW GameRound_Coordinator
GO
CREATE VIEW GameRound_Coordinator AS
	SELECT GameRound.tournament_id, GameRound.gamenumber, GameRound.id
		FROM GameRound, Users, Tournament
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Сoordinator') = 1
		AND GameRound.tournament_id = Tournament.id
		AND Tournament.address_id = Users.address_id
WITH CHECK OPTION;
		
GO
IF OBJECT_ID('GameRound_Organizer', 'V') IS NOT NULL
	DROP VIEW GameRound_Organizer
GO
CREATE VIEW GameRound_Organizer AS
	SELECT GameRound.tournament_id, GameRound.gamenumber, GameRound.id
		FROM GameRound, Users, Tournament
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Organizer') = 1
		AND GameRound.tournament_id = Users.tournament_id
WITH CHECK OPTION;

GO
IF OBJECT_ID('Tournament_Coordinator', 'V') IS NOT NULL
	DROP VIEW Tournament_Coordinator
GO
CREATE VIEW Tournament_Coordinator AS
	SELECT Tournament.id, Tournament.name, Tournament.address_id, Tournament.password, Tournament.season_id
		FROM Tournament, Users
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Сoordinator') = 1
		AND Tournament.address_id = Users.address_id
WITH CHECK OPTION;

GO
IF OBJECT_ID('Tournament_Organizer', 'V') IS NOT NULL
	DROP VIEW Tournament_Organizer
GO
CREATE VIEW Tournament_Organizer AS
	SELECT Tournament.id, Tournament.name, Tournament.address_id, Tournament.password, Tournament.season_id
		FROM Tournament, Users
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Organizer') = 1
		AND Tournament.id = Users.tournament_id
WITH CHECK OPTION;

GO
IF OBJECT_ID ('TeamTournament_Coordinator', 'V') IS NOT NULL
	DROP VIEW TeamTournament_Coordinator;
GO
CREATE VIEW TeamTournament_Coordinator AS
	SELECT TeamTournament.tournament_id, TeamTournament.team_id, TeamTournament.age_category_id, TeamTournament.regcard_number
		FROM TeamTournament, Users, Tournament
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Coordinator') = 1
		AND TeamTournament.tournament_id = Tournament.id
		AND Tournament.address_id = Users.address_id
WITH CHECK OPTION;
GO

GO
IF OBJECT_ID ('TeamTournament_Organizer', 'V') IS NOT NULL
	DROP VIEW TeamTournament_Organizer;
GO
CREATE VIEW TeamTournament_Organizer AS
	SELECT TeamTournament.tournament_id, TeamTournament.team_id, TeamTournament.age_category_id, TeamTournament.regcard_number
		FROM TeamTournament, Users
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Organizer') = 1
		AND TeamTournament.tournament_id = Users.tournament_id
WITH CHECK OPTION;
GO

IF OBJECT_ID ('Team_Coordinator', 'V') IS NOT NULL
DROP VIEW Team_Coordinator;
GO
CREATE VIEW Team_Coordinator AS
SELECT Team.id, Team.name, Team.phone, Team.email, Team.captain_id, Team.address_id
FROM TeamTournament, Users, Team, Tournament
WHERE Users.name = CURRENT_USER
AND IS_MEMBER('Coordinator') = 1
AND TeamTournament.tournament_id = Tournament.id
AND Tournament.address_id = Users.address_id
AND TeamTournament.team_id = Team.id
WITH CHECK OPTION;
GO

IF OBJECT_ID ('Team_Organizer', 'V') IS NOT NULL
DROP VIEW Team_Organizer;
GO
CREATE VIEW Team_Organizer AS
SELECT Team.id, Team.name, Team.phone, Team.email, Team.captain_id, Team.address_id
FROM TeamTournament, Users, Team
WHERE Users.name = CURRENT_USER
AND IS_MEMBER('Organizer') = 1
AND TeamTournament.tournament_id = Users.tournament_id
AND TeamTournament.team_id = Team.id
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
		WHERE gameround_id = 1
	) x
	PIVOT
	(
	COUNT(id)
	FOR question_num IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31], [32], [33], [34], [35], [36])
	) p;
GO