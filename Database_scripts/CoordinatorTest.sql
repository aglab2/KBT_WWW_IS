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
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE loginname='Petya')
BEGIN
	DROP SCHEMA Petya;
	DROP LOGIN Petya;
	DROP USER Petya;
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE loginname='Kolya')
BEGIN
	DROP SCHEMA Kolya;
	DROP LOGIN Kolya;
	DROP USER Kolya;
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE loginname='Oleg')
BEGIN
	DROP SCHEMA Oleg;
	DROP LOGIN Oleg;
	DROP USER Oleg;
END

IF DATABASE_PRINCIPAL_ID('Coordinator') IS NOT NULL
BEGIN
	DROP ROLE Coordinator;
END

CREATE ROLE Coordinator

GRANT SELECT, INSERT, UPDATE ON GameRound_User TO Coordinator
GRANT SELECT ON Season TO Coordinator
GRANT SELECT ON PlayerTeamGameround TO Coordinator
GRANT SELECT ON AgeCategory TO Coordinator
GRANT SELECT ON AddressType TO Coordinator
GRANT SELECT ON PlayerSeason TO Coordinator
GRANT SELECT ON History TO Coordinator
GRANT SELECT ON EntityAttributeDict TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON Tournament_User TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON TeamTournament_User TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON GameRound_User TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON Team_User TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON Player_User TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON Answer_User TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON Question TO Coordinator
GRANT SELECT, INSERT, UPDATE, DELETE ON Address TO Coordinator
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
	IF @address_id IS NULL
	BEGIN
		DECLARE @address_type_id INT
		SET @address_type_id = (SELECT id FROM AddressType WHERE name = 'City')
		INSERT INTO Address (type_id, name) VALUES (@address_type_id, @address_name)
		SET @address_id = IDENT_CURRENT('Address')
	END
	INSERT INTO Users (name, userrole, season_id, address_id, tournament_id)
	VALUES (@name, 'Coordinator', @season_id, @address_id, @tournament_id)
GO --TODO DROP USER Trigger

IF DATABASE_PRINCIPAL_ID('Organizer') IS NOT NULL
BEGIN
	DROP ROLE Organizer;
END

CREATE ROLE Organizer

GRANT SELECT ON Season TO Organizer
GRANT SELECT ON PlayerTeamGameround TO Organizer
GRANT SELECT ON AgeCategory TO Organizer
GRANT SELECT ON AddressType TO Organizer
GRANT SELECT ON PlayerSeason TO Organizer
GRANT SELECT ON History TO Organizer
GRANT SELECT ON EntityAttributeDict TO Organizer
--GRANT SELECT ON Users TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON TeamTournament_User TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON GameRound_User TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON Team_User TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON Player_User TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON Answer_User TO Organizer
GRANT SELECT, INSERT, UPDATE, DELETE ON Question TO Organizer
go

IF OBJECT_ID ('addOrganizerUser', 'P') IS NOT NULL
   DROP PROCEDURE addOrganizerUser;
GO

CREATE PROCEDURE addOrganizerUser(
	@name nvarchar(255),
	@password nvarchar(255),
	@tournament_id integer,
	@season_id integer,
	@address_name nvarchar(255))
AS
	EXEC sp_addlogin @name, @password;
	EXEC sp_adduser @name, @name, 'Organizer'
	DECLARE @address_id INT;
	SET @address_id = (SELECT id FROM Address WHERE Address.name = @address_name)
	INSERT INTO Users (name, userrole, season_id, address_id, tournament_id)
	VALUES (@name, 'Organizer', @season_id, @address_id, @tournament_id)
GO

IF DATABASE_PRINCIPAL_ID('Jury') IS NOT NULL
BEGIN
	DROP ROLE Jury;
END
IF DATABASE_PRINCIPAL_ID('AppelJury') IS NOT NULL
BEGIN
	DROP ROLE AppelJury;
END

CREATE ROLE Jury
CREATE ROLE AppelJury

GRANT SELECT, UPDATE, INSERT, DELETE ON Answer_User TO Jury;
GRANT SELECT, UPDATE, INSERT, DELETE ON Question TO Jury;

GRANT SELECT ON Tournament_User TO Jury;
GRANT SELECT ON TeamTournament_User TO Jury;
GRANT SELECT ON GameRound_User TO Jury;
GRANT SELECT ON Team_User TO Jury;
GRANT SELECT ON Address TO Jury;

GRANT SELECT, UPDATE ON Answer_User TO AppelJury;
GRANT SELECT ON Tournament_User TO AppelJury;
GRANT SELECT ON TeamTournament_User TO AppelJury;
GRANT SELECT ON GameRound_User TO AppelJury;
GRANT SELECT ON Team_User TO AppelJury;
GRANT SELECT ON Address TO AppelJury;
go

IF OBJECT_ID ('addJuryUser', 'P') IS NOT NULL
   DROP PROCEDURE addJuryUser;
GO

CREATE PROCEDURE addJuryUser(
	@name nvarchar(255),
	@password nvarchar(255),
	@tournament_id int,
	@season_id integer,
	@address_name nvarchar(255))
AS
	EXEC sp_addlogin @name, @password;
	EXEC sp_adduser @name, @name, 'Jury'
	DECLARE @address_id INT;
	SET @address_id = (SELECT id FROM Address WHERE Address.name = @address_name)
	INSERT INTO Users (name, userrole, season_id, address_id, tournament_id)
	VALUES (@name, 'Jury', @season_id, @address_id, @tournament_id)
GO --TODO DROP USER Trigger

IF OBJECT_ID ('addAppelJuryUser', 'P') IS NOT NULL
   DROP PROCEDURE addAppelJuryUser;
GO

CREATE PROCEDURE addAppelJuryUser(
	@name nvarchar(255),
	@password nvarchar(255),
	@tournament_id int,
	@season_id integer,
	@address_name nvarchar(255))
AS
	EXEC sp_addlogin @name, @password;
	EXEC sp_adduser @name, @name, 'AppelJury'
	DECLARE @address_id INT;
	SET @address_id = (SELECT id FROM Address WHERE Address.name = @address_name)
	INSERT INTO Users (name, userrole, season_id, address_id, tournament_id)
	VALUES (@name, 'AppelJury', @season_id, @address_id, @tournament_id)
GO

EXEC addCoordinatorUser @name = 'Vasya2', @password='123', @season_id = 1, @address_name = 'Москва', @tournament_id = 2;
EXEC addOrganizerUser @name = 'Petya', @password='123', @season_id = 1, @address_name = 'Москва', @tournament_id = 2;
EXEC addJuryUser @name = 'Kolya', @password='123', @season_id = 1, @address_name = 'Москва', @tournament_id = 2; 
EXEC addAppelJuryUser @name = 'Oleg', @password='123', @season_id = 1, @address_name = 'Москва', @tournament_id = 2;


IF OBJECT_ID ('DROP_USER_TRIGGER', 'TR') IS NOT NULL
   DROP TRIGGER DROP_USER_TRIGGER;
GO

CREATE TRIGGER DROP_USER_TRIGGER 
	ON Users
	FOR DELETE
AS
	DECLARE @cur_name NVARCHAR(MAX)
	DECLARE cursor_del CURSOR FOR
	SELECT name
	FROM deleted

	OPEN cursor_del
	FETCH NEXT FROM cursor_del
	INTO @cur_name	
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		EXEC sp_dropuser @cur_name 
		EXEC sp_droplogin @cur_name
		FETCH NEXT FROM cursor_del
		INTO @cur_name
	END
	CLOSE cursor_del
	DEALLOCATE cursor_del
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'DROP_USER_TRIGGER_REV')
DROP TRIGGER DROP_USER_TRIGGER_REV ON DATABASE;

GO
CREATE TRIGGER DROP_USER_TRIGGER_REV 
	ON DATABASE
	FOR DROP_USER
AS
	DECLARE @username NVARCHAR(MAX)
	SET @username = EVENTDATA().value('(/EVENT_INSTANCE/UserName)[1]','nvarchar(max)')
	DELETE FROM Users WHERE name = @username
GO

/*
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
*/
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