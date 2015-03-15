--ѕри удаление команды каскадное удаление. ѕроверить работоспособность. 
--ѕомен€ть у участника сменить тип данных

ALTER TABLE PlayerSeason
	DROP CONSTRAINT FK_PlayerSeason_Player;
ALTER TABLE PlayerTeamGameround
	DROP CONSTRAINT FK_PlayerTeamGameround_Player;
ALTER TABLE Team
	DROP CONSTRAINT FK_Team_Captain;
ALTER TABLE Player
	DROP CONSTRAINT PK_Player; 
ALTER TABLE PlayerSeason
	DROP CONSTRAINT PK_PlayerSeason;
ALTER TABLE PlayerTeamGameround
	DROP CONSTRAINT PK_PlayerTeamGameround;



ALTER TABLE Player
	ALTER COLUMN id BIGINT NOT NULL;
ALTER TABLE PlayerSeason
	ALTER COLUMN player_id BIGINT NOT NULL;
ALTER TABLE PlayerTeamGameround
	ALTER COLUMN player_id BIGINT NOT NULL;
ALTER TABLE Team
	ALTER COLUMN captain_id BIGINT;



ALTER TABLE PlayerSeason
	ADD CONSTRAINT PK_PlayerSeason PRIMARY KEY (player_id ASC, season_id ASC);
ALTER TABLE PlayerTeamGameround
	ADD CONSTRAINT PK_PlayerTeamGameround PRIMARY KEY (
		player_id ASC,
		team_id ASC,
		gameround_id ASC
	);
ALTER TABLE Player
	ADD CONSTRAINT PK_Player PRIMARY KEY (id ASC);
ALTER TABLE PlayerSeason
	ADD CONSTRAINT FK_PlayerSeason_Player FOREIGN KEY (player_id)
		REFERENCES Player(id);
ALTER TABLE PlayerTeamGameround
	ADD CONSTRAINT FK_PlayerTeamGameround_Player FOREIGN KEY (player_id)
		REFERENCES Player(id);
ALTER TABLE Team
	ADD CONSTRAINT FK_Team_Captain FOREIGN KEY (captain_id)
		REFERENCES Player(id);	