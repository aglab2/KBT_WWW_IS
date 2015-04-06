GO
IF OBJECT_ID('GameRound_User', 'V') IS NOT NULL
	DROP VIEW GameRound_User
GO
CREATE VIEW GameRound_User AS
	SELECT GameRound.tournament_id, GameRound.gamenumber, GameRound.id
		FROM GameRound, Users
		WHERE Users.name = CURRENT_USER
		AND GameRound.tournament_id = Users.tournament_id