USE [kbt-project];
/*Tables and constraints*/
CREATE TABLE AddressType (
	id   integer IDENTITY(1,1) NOT NULL,
	name nvarchar(max) NOT NULL,
	CONSTRAINT PK_AddressType PRIMARY KEY (id ASC)
);

CREATE TABLE Address (
	id        integer IDENTITY(1,1) NOT NULL,
	parent_id integer,
	type_id   integer NOT NULL,
	name      nvarchar(255) NOT NULL,
	CONSTRAINT PK_Address PRIMARY KEY (id ASC),
	CONSTRAINT FK_Address_AddressType FOREIGN KEY (type_id)
		REFERENCES AddressType(id),
	CONSTRAINT FK_Address_Address FOREIGN KEY (parent_id)
		REFERENCES Address(id),
	CONSTRAINT U_Address UNIQUE(name),
	CONSTRAINT Chk_AddressName CHECK (name NOT LIKE '%@%')
);

CREATE TABLE Team (
	id         integer IDENTITY(1,1) NOT NULL,
	name       nvarchar(255) NOT NULL,
	phone      nvarchar(max),
	email      nvarchar(max),
	captain_id integer,	
	address_id integer,
	CONSTRAINT PK_Team PRIMARY KEY (id ASC),
	CONSTRAINT FK_Team_Address FOREIGN KEY (address_id)
		REFERENCES Address(id),
	CONSTRAINT U_Team UNIQUE(name)
);

CREATE TABLE Player (
	id       integer IDENTITY(1,1) NOT NULL,
	team_id  integer,
	name     nvarchar(255) NOT NULL,
	birthday smalldatetime,
	CONSTRAINT PK_Player PRIMARY KEY (id ASC),
	CONSTRAINT FK_Player_Team FOREIGN KEY (team_id)
		REFERENCES Team(id) ON DELETE SET NULL,
	CONSTRAINT U_Player UNIQUE(name, birthday)
);

ALTER TABLE Team
	ADD CONSTRAINT FK_Team_Captain FOREIGN KEY (captain_id)
		REFERENCES Player(id);

CREATE TABLE Season (
	id         integer IDENTITY(1,1) NOT NULL,
	begin_date smalldatetime NOT NULL,
	end_date   smalldatetime NOT NULL
	CONSTRAINT PK_Season PRIMARY KEY (id ASC),
	CONSTRAINT U_Season UNIQUE(begin_date, end_date)
);

CREATE TABLE Tournament (
	id         integer IDENTITY(1,1) NOT NULL,
	name       nvarchar(255) NOT NULL,
	address_id integer NOT NULL,
	password   nvarchar(max),
	season_id  integer NOT NULL,
	CONSTRAINT PK_Tournament PRIMARY KEY (id ASC),
	CONSTRAINT FK_Tournament_Season FOREIGN KEY (season_id)
		REFERENCES Season(id),
	CONSTRAINT FK_Tournament_Address FOREIGN KEY (address_id)
		REFERENCES Address(id),
	CONSTRAINT U_Tournament UNIQUE (name, address_id)
);

CREATE TABLE GameRound (
	id            integer IDENTITY(1,1) NOT NULL,
	tournament_id integer NOT NULL,
	gamenumber    integer NOT NULL,
	CONSTRAINT PK_GameRound PRIMARY KEY (id ASC),
	CONSTRAINT FK_GameRound_Tournament FOREIGN KEY (tournament_id)
		REFERENCES Tournament(id) ON DELETE CASCADE
);

CREATE TABLE Question (
	id                  integer IDENTITY(1,1) NOT NULL,
	autors_answer       nvarchar(max),
	validity_criterion  nvarchar(max),
	autor               nvarchar(max),
	source              nvarchar(max),
	note                nvarchar(max),
	commentary          nvarchar(max),
	CONSTRAINT PK_Question PRIMARY KEY (id ASC)
);

CREATE TABLE Answer (
	id           integer IDENTITY(1,1) NOT NULL,
	gameround_id integer NOT NULL,
	team_id      integer NOT NULL,
	question_id  integer,
	question_num integer NOT NULL,
	answer_text  nvarchar(max),
	is_valid     bit,
	CONSTRAINT FK_Answer_GameRound FOREIGN KEY (gameround_id)
		REFERENCES GameRound(id),
	CONSTRAINT FK_Answer_Team FOREIGN KEY (team_id)
		REFERENCES Team(id) ON DELETE CASCADE,
	CONSTRAINT FK_Answer_Question FOREIGN KEY (question_id)
		REFERENCES Question(id),
	CONSTRAINT U_Answer UNIQUE (
		gameround_id ASC,
		team_id ASC,
		question_num ASC
	),
	CONSTRAINT PK_Answer PRIMARY KEY (id ASC)
);
/*
CREATE UNIQUE INDEX IX_Answer ON Answer (
	gameround_id ASC,
	team_id ASC,
	question_id ASC
);
*/
CREATE TABLE TeamTournament (
	team_id        integer NOT NULL,
	tournament_id  integer NOT NULL,
	regcard_number nvarchar(max),
	age_category_id   integer NOT NULL, --NOT NULL: это нужно?
	CONSTRAINT FK_TeamTournament_Team FOREIGN KEY (team_id)
		REFERENCES Team(id) ON DELETE CASCADE,
	CONSTRAINT FK_TeamTournament_Tournament FOREIGN KEY (tournament_id)
		REFERENCES Tournament(id) ON DELETE CASCADE,
	CONSTRAINT PK_TeamTournament PRIMARY KEY (
		team_id ASC,
		tournament_id ASC
	)
);

CREATE TABLE PlayerTeamGameround (
	player_id    integer NOT NULL,
	gameround_id integer NOT NULL,
	team_id      integer NOT NULL,
	CONSTRAINT FK_PlayerTeamGameround_Player FOREIGN KEY (player_id)
		REFERENCES Player(id) ON DELETE CASCADE,
	CONSTRAINT FK_PlayerTeamGameround_Team FOREIGN KEY (team_id)
		REFERENCES Team(id) ON DELETE CASCADE,
	CONSTRAINT FK_PlayerTeamGameround_GameRound FOREIGN KEY (gameround_id)
		REFERENCES GameRound(id) ON DELETE CASCADE,
	CONSTRAINT PK_PlayerTeamGameround PRIMARY KEY (
		player_id ASC,
		team_id ASC,
		gameround_id ASC
	)
);

CREATE TABLE PlayerSeason (
	player_id   integer NOT NULL,
	season_id   integer NOT NULL,
	schoolgrade integer,
	CONSTRAINT FK_PlayerSeason_Player FOREIGN KEY (player_id)
		REFERENCES Player(id) ON DELETE CASCADE,
	CONSTRAINT FK_PlayerSeason_Season FOREIGN KEY (season_id)
		REFERENCES Season(id),
	CONSTRAINT PK_PlayerSeason PRIMARY KEY (
		player_id ASC,
		season_id ASC
	)
);

CREATE TABLE EntityAttributeDict (
	id   integer IDENTITY(1,1) NOT NULL,
	name nvarchar(300) NOT NULL,
	CONSTRAINT PK_EntityAttributeDict PRIMARY KEY (id ASC),
	CONSTRAINT U_EntityAttributeDict UNIQUE (name)
);

CREATE TABLE History (
	instance_id        integer NOT NULL,
	attribute_id       integer NOT NULL,
	modification_date  datetime,
	previous_value     nvarchar(max),
	CONSTRAINT FK_History_EntityAttributeDict FOREIGN KEY (attribute_id)
		REFERENCES EntityAttributeDict(id),
	CONSTRAINT PK_History PRIMARY KEY (
		attribute_id ASC,
		instance_id ASC,
		modification_date ASC
	)
);

CREATE TABLE ExternalT (
	id           integer NOT NULL,
	instance_id  integer NOT NULL,
	attribute_id integer NOT NULL,
	value        nvarchar(max),
	CONSTRAINT FK_ExternalT_EntityAttributeDict FOREIGN KEY (attribute_id)
		REFERENCES EntityAttributeDict(id),
	CONSTRAINT U_ExternalT UNIQUE (
		attribute_id ASC,
		instance_id ASC
	),
	CONSTRAINT PK_ExternalT PRIMARY KEY (id ASC)
);

CREATE TABLE AgeCategory (
	id    integer IDENTITY(1,1) NOT NULL,
	clgroup integer NOT NULL,
	name  nvarchar(max) NOT NULL,
	CONSTRAINT PK_AgeCategory PRIMARY KEY (id ASC)
);
