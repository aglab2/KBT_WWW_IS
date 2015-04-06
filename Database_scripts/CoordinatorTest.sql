IF OBJECT_ID ('Users', 'U') IS NOT NULL
   DROP TABLE Users;
GO

CREATE TABLE Users(
	id integer IDENTITY(1,1) NOT NULL,
	name      nvarchar(255) UNIQUE NOT NULL,
	userrole  nvarchar(25) NOT NULL,
	season_id integer NOT NULL,
	address_id integer NOT NULL,
	tournament_id int NOT NULL
);
GO

IF EXISTS (SELECT * FROM sys.syslogins WHERE loginname='Vasya2')
BEGIN
	DROP SCHEMA Vasya2;
	DROP LOGIN Vasya2;
	DROP USER Vasya2;
	DROP ROLE Coordinator;
END

IF DATABASE_PRINCIPAL_ID('Coordinator') IS NOT NULL
BEGIN
	DROP ROLE Coordinator;
END

CREATE ROLE Coordinator

GRANT SELECT, INSERT, UPDATE ON GameRound_User TO Coordinator
GRANT SELECT ON OBJECT::dbo.Season TO Coordinator
GRANT SELECT ON OBJECT::dbo.PlayerTeamGameround TO Coordinator
GRANT SELECT ON OBJECT::dbo.AgeCategory TO Coordinator
GRANT SELECT ON OBJECT::dbo.AddressType TO Coordinator
GRANT SELECT ON OBJECT::dbo.PlayerSeason TO Coordinator
GRANT SELECT ON OBJECT::dbo.History TO Coordinator
GRANT SELECT ON OBJECT::dbo.EntityAttributeDict TO Coordinator
GRANT SELECT ON OBJECT::dbo.Users TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Tournament TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.TeamTournament TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.GameRound TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Team TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Player TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Answer TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Question TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Address TO Coordinator
go

IF OBJECT_ID ('addCoordinatorUser', 'P') IS NOT NULL
   DROP PROCEDURE addCoordinatorUser;
GO

CREATE PROCEDURE addCoordinatorUser(
	@name nvarchar(255),
	@password nvarchar(255),
	@tournament_id int,
	@season_id integer,
	@address_name nvarchar(255))
AS
	EXEC sp_addlogin @name, @password;
	EXEC sp_adduser @name, @name, 'Coordinator'
	DECLARE @address_id INT;
	SET @address_id = (SELECT id FROM Address WHERE Address.name = @address_name)
	INSERT INTO Users (name, userrole, season_id, address_id, tournament_id)
	VALUES (@name, 'Coordinator', @season_id, @address_id, @tournament_id)
GO --TODO DROP USER Trigger

EXEC addCoordinatorUser @name = 'Vasya2', @password='123', @season_id = 1, @address_name = 'Москва', @tournament_id = 2;

IF OBJECT_ID ('GameRound_Update_Coordinator', 'TR') IS NOT NULL
   DROP TRIGGER GameRound_Update_Coordinator;
GO

CREATE TRIGGER GameRound_Update_Coordinator
	ON GameRound
	INSTEAD OF UPDATE
AS	
	DECLARE @user_name NVARCHAR(255);
	SET @user_name = (SELECT CURRENT_USER);

	DECLARE @userrole  nvarchar(25);
	DECLARE @tournament_id  int;
	DECLARE @season_id integer;
	DECLARE @address_id integer;

	SET @userrole = (SELECT userrole FROM Users WHERE Users.name = @user_name);
	SET @season_id  = (SELECT season_id FROM Users WHERE Users.name = @user_name);
	SET @address_id = (SELECT address_id FROM Users WHERE Users.name = @user_name);
	SET @tournament_id = (SELECT tournament_id FROM Users WHERE Users.name = @user_name);

	IF (@userrole != 'Coordinator') RETURN;
	
	UPDATE GameRound SET GameRound.tournament_id=s.tournament_id, GameRound.gamenumber=s.gamenumber
		FROM inserted s, GameRound 
		WHERE s.tournament_id = @tournament_id
		AND s.id = GameRound.id;
GO

-- Составляем отчет обо всех пользователях базы данных, утративших связь с именем входа
--EXECUTE sp_change_users_login @Action='Report';

/* Права, предоставленные...
SELECT dp.class_desc, s.name AS 'Schema', o.name AS 'Object', dp.permission_name, 
       dp.state_desc, prin.[name] AS 'User'
FROM sys.database_permissions dp
  JOIN sys.database_principals prin
    ON dp.grantee_principal_id = prin.principal_id
  JOIN sys.objects o
    ON dp.major_id = o.object_id
  JOIN sys.schemas s
    ON o.schema_id = s.schema_id
WHERE  dp.class_desc = 'OBJECT_OR_COLUMN'
UNION ALL
SELECT dp.class_desc, s.name AS 'Schema', '-----' AS 'Object', dp.permission_name, 
       dp.state_desc, prin.[name] AS 'User'
FROM sys.database_permissions dp
  JOIN sys.database_principals prin
    ON dp.grantee_principal_id = prin.principal_id
  JOIN sys.schemas s
    ON dp.major_id = s.schema_id
WHERE dp.class_desc = 'SCHEMA'*/