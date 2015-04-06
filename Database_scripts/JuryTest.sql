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

GRANT SELECT, UPDATE, INSERT, DELETE ON Answer_Role TO Jury;
GRANT SELECT, UPDATE, INSERT, DELETE ON Question_Role TO Jury;

GRANT SELECT ON Tournament_Role TO Jury;
GRANT SELECT ON TeamTournament_Role TO Jury;
GRANT SELECT ON GameRound_Role TO Jury;
GRANT SELECT ON Team_Role TO Jury;
GRANT SELECT ON Address_Role TO Jury;

GRANT SELECT, UPDATE ON Answer_Role TO AppelJury;
GRANT SELECT ON Tournament_Role TO AppelJury;
GRANT SELECT ON TeamTournament_Role TO AppelJury;
GRANT SELECT ON GameRound_Role TO AppelJury;
GRANT SELECT ON Team_Role TO AppelJury;
GRANT SELECT ON Address_Role TO AppelJury;
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
GO --TODO DROP USER Trigger


--EXEC addOrganizerUser @name = 'Vasya2', @password='123', @season_id = 1, @address_name = 'Москва', @tournament_name = 'ШРеК';

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