SELECT *
FROM Player, PlayerTeamGameround, Team, "Address"
WHERE Player.id = PlayerTeamGameround.player_id AND PlayerTeamGameround.team_id = Team.id
		AND Player.team_id !=PlayerTeamGameround.team_id and "Address".id = Team.address_id