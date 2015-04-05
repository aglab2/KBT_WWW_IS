CREATE VIEW Coordinator_Competantion_Tournament
AS SELECT * 
    FROM Tournament 
    WHERE name = 'ШРеК' AND address_id = 1
    WITH CHECK OPTION;
GO

DROP USER Coordinator007
DROP LOGIN Coordinator007
DROP ROLE Coordinator
	
CREATE ROLE Coordinator;	

CREATE LOGIN Coordinator007 
	WITH PASSWORD = '007',
		DEFAULT_DATABASE = KBT_IS;

CREATE USER Coordinator007  FOR LOGIN Coordinator007;
EXEC sp_addrolemember @rolename = 'Coordinator', @membername = 'Coordinator007';

GRANT UPDATE, ON Coordinator_Competantion_Tournament TO Coordinator007; 

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON Player TO Coordinator
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON Team TO Coordinator
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON GameRound TO Coordinator
GRANT EXECUTE ON OBJECT::dbo.addTeam2Tournament TO Coordinator
go


-- Составляем отчет обо всех пользователях базы данных, утративших связь с именем входа
EXECUTE sp_change_users_login @Action='Report';

-- Проверяем, принадлежит ли текущий пользователь к роли db_owner
SELECT IS_MEMBER ("db_owner");

-- Права, предоставленные...
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
WHERE dp.class_desc = 'SCHEMA'