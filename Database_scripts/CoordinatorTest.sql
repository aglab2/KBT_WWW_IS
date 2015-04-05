CREATE TABLE Users(
	id integer IDENTITY(1,1) NOT NULL,
	name      nvarchar(255) NOT NULL,
	userrole  nvarchar(25) NOT NULL,
	season_id integer NOT NULL,
	address_id integer NOT NULL,
	tournament_name nvarchar(255) NOT NULL
);
GO

CREATE ROLE Coordinator

GRANT SELECT ON OBJECT::dbo.Season TO Coordinator
GRANT SELECT ON OBJECT::dbo.PlayerTeamGameround TO Coordinator
GRANT SELECT ON OBJECT::dbo.AgeCategory TO Coordinator
GRANT SELECT ON OBJECT::dbo.AddressType TO Coordinator
GRANT SELECT ON OBJECT::dbo.PlayerSeason TO Coordinator
GRANT SELECT ON OBJECT::dbo.History TO Coordinator
GRANT SELECT ON OBJECT::dbo.EntityAttributeDict TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Tournament TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.TeamTournament TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.GameRound TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Team TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Player TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Answer TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Question TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON OBJECT::dbo.Address TO Coordinator
go

CREATE PROCEDURE addCoordinatorUser(
	@name nvarchar(255),
	@password nvarchar(255),
	@tournament_name nvarchar(255),
	@season_id integer,
	@address_name nvarchar(255))
AS
	EXEC sp_addlogin @name, @password;
	EXEC sp_adduser @name, @name, 'Coordinator'
	DECLARE @address_id INT;
	SET @address_id = (SELECT id FROM Address WHERE Address.name = @address_name)
	INSERT INTO Users (name, userrole, season_id, address_id, tournament_name)
	VALUES (@name, 'Coordinator', @season_id, @address_id, @tournament_name)
GO

exec addCoordinatorUser @name = 'Vasya2', @password='123', @season_id = 1, @address_name = 'Москва', @tournament_name = 'ШРеК';

IF OBJECT_ID ('Concret_GameRound_Update_Coordinator', 'TR') IS NOT NULL
   DROP TRIGGER Concret_GameRound_Update_Coordinator;
GO

CREATE TRIGGER Concret_GameRound_Update_Coordinator
	ON GameRound
	INSTEAD OF UPDATE
AS	
	DECLARE @user_name NVARCHAR(255);
	SET @user_name = (SELECT CURRENT_USER);

	DECLARE @userrole  nvarchar(25);
	DECLARE @tournament_name  nvarchar(255);
	DECLARE @season_id integer;
	DECLARE @address_id integer;

	SET @userrole = (SELECT season_id FROM Users WHERE Users.name = @user_name);
	SET @season_id  = (SELECT season_id FROM Users WHERE Users.name = @user_name);
	SET @address_id = (SELECT address_id FROM Users WHERE Users.name = @user_name);
	SET @tournament_name = (SELECT tournament_name FROM Users WHERE Users.name = @user_name);

	IF (@userrole != 'Coordinator') RETURN;
	
	DECLARE @tournament_id integer;
	SET @tournament_id = (SELECT id FROM Tournament WHERE Tournament.name = @tournament_name AND Tournament.address_id = @address_id AND Tournament.season_id = @season_id AND Tournament.address_id = @address_id);

	INSERT INTO GameRound
	VALUES (SELECT * FROM inserted WHERE inserted.tournament_id = @tournament_id);
GO

DROP PROCEDURE addCoordinatorUser;
DROP LOGIN Vasya
DROP USER Vasya
DROP TABLE Users;
DROP ROLE Coordinator
	





go

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