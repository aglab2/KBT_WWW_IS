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