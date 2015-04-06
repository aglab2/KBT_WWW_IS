GO
IF OBJECT_ID ('Player_Coordinator', 'V') IS NOT NULL
	DROP VIEW TeamTournament_Coordinator;
GO
CREATE VIEW Player_Coordinator AS
	SELECT Player.id, Player.name, Player.birthday, Player.team_id
		FROM PlayerSeason, Player, Users, Tournament
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Coordinator') = 1
		AND Tournament.address_id = Users.address_id
		AND Tournament.season_id = PlayerSeason.season_id
		AND PlayerSeason.player_id = Player.id
WITH CHECK OPTION;
GO

GO
IF OBJECT_ID ('Player_Organizer', 'V') IS NOT NULL
	DROP VIEW Player_Organizer;
GO
CREATE VIEW Player_Organizer AS
	SELECT Player.id, Player.name, Player.birthday, Player.team_id
	FROM PlayerSeason, Player, Users, Tournament
		WHERE Users.name = CURRENT_USER
		AND IS_MEMBER('Organizer') = 1
		AND Tournament.id = Users.tournament_id
		AND Tournament.season_id = PlayerSeason.season_id
		AND PlayerSeason.player_id = Player.id
WITH CHECK OPTION;
GO