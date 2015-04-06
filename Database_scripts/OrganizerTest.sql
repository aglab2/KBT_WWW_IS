IF DATABASE_PRINCIPAL_ID('Organizer') IS NOT NULL
BEGIN
	DROP ROLE Organizer;
END

CREATE ROLE Organizer

GRANT SELECT ON OBJECT::dbo.Season TO Organizer
GRANT SELECT ON OBJECT::dbo.PlayerTeamGameround TO Organizer
GRANT SELECT ON OBJECT::dbo.AgeCategory TO Organizer
GRANT SELECT ON OBJECT::dbo.AddressType TO Organizer
GRANT SELECT ON OBJECT::dbo.PlayerSeason TO Organizer
GRANT SELECT ON OBJECT::dbo.History TO Organizer
GRANT SELECT ON OBJECT::dbo.EntityAttributeDict TO Organizer
GRANT SELECT ON OBJECT::dbo.Users TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.TeamTournament TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.GameRound TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Team TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Player TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Answer TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Question TO Organizer
go

IF OBJECT_ID ('addOrganizerUser', 'P') IS NOT NULL
   DROP PROCEDURE addOrganizerUser;
GO

CREATE PROCEDURE addOrganizerUser(
	@name nvarchar(255),
	@password nvarchar(255),
	@tournament_name nvarchar(255),
	@season_id integer,
	@address_name nvarchar(255))
AS
	EXEC sp_addlogin @name, @password;
	EXEC sp_adduser @name, @name, 'Organizer'
	DECLARE @address_id INT;
	SET @address_id = (SELECT id FROM Address WHERE Address.name = @address_name)
	INSERT INTO Users (name, userrole, season_id, address_id, tournament_name)
	VALUES (@name, 'Organizer', @season_id, @address_id, @tournament_name)
GO --TODO DROP USER Trigger

--EXEC addOrganizerUser @name = 'Vasya2', @password='123', @season_id = 1, @address_name = 'Москва', @tournament_name = 'ШРеК';

IF OBJECT_ID ('GameRound_Update_Organizer', 'TR') IS NOT NULL
   DROP TRIGGER GameRound_Update_Organizer;
GO

CREATE TRIGGER GameRound_Update_Organizer
	ON GameRound
	INSTEAD OF UPDATE
AS	
	DECLARE @user_name NVARCHAR(255);
	SET @user_name = (SELECT CURRENT_USER);

	DECLARE @userrole  nvarchar(25);
	DECLARE @tournament_name  nvarchar(255);
	DECLARE @season_id integer;
	DECLARE @address_id integer;

	SET @userrole = (SELECT userrole FROM Users WHERE Users.name = @user_name);
	SET @season_id  = (SELECT season_id FROM Users WHERE Users.name = @user_name);
	SET @address_id = (SELECT address_id FROM Users WHERE Users.name = @user_name);
	SET @tournament_name = (SELECT tournament_name FROM Users WHERE Users.name = @user_name);

	IF (@userrole != 'Organizer') RETURN;
	
	DECLARE @tournament_id integer;
	SET @tournament_id = (SELECT id FROM Tournament WHERE Tournament.name = @tournament_name AND Tournament.season_id = @season_id);

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