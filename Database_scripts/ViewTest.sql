GO
IF OBJECT_ID('GameRound_Coordinator', 'V') IS NOT NULL
	DROP VIEW GameRound_Coordinator
GO
CREATE VIEW GameRound_Coordinator AS
	SELECT GameRound.tournament_id, GameRound.gamenumber, GameRound.id
		FROM GameRound, Users
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Сoordinator') = 1
		AND GameRound.tournament_id = Tournament.id
		AND Tournament.address_id = Users.address_id
		
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

GO
IF OBJECT_ID('Tournament_Organizer', 'V') IS NOT NULL
	DROP VIEW Tournament_Organizer
GO
CREATE VIEW Tournament_Organizer AS
	SELECT Tournament.id, Tournament.name, Tournament.address_id, Tournament.password, Tournament.season_id
		FROM Tournament, Users
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Organizer') = 1
		AND Tournament.tournament_id = Users.tournament_id