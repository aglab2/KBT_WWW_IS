DROP LOGIN Jury_login;
DROP LOGIN Appel_login;
DROP USER TestJury;
DROP USER TestAppelJury;
DROP ROLE Jury;
DROP ROLE AppelJury;

CREATE ROLE Jury;
CREATE ROLE AppelJury;

GRANT SELECT, UPDATE, INSERT, DELETE ON Answer TO Jury;
GRANT SELECT, UPDATE, INSERT, DELETE ON Question TO Jury;
GRANT EXECUTE ON addAnswer TO Jury;
GRANT EXECUTE ON addAnswerByGlobalID TO Jury;

GRANT SELECT ON Tournament TO Jury;
GRANT SELECT ON TeamTournament TO Jury;
GRANT SELECT ON GameRound TO Jury;
GRANT SELECT ON Team TO Jury;
GRANT SELECT ON Address TO Jury;

GRANT SELECT, UPDATE ON Answer TO AppelJury;

CREATE LOGIN Jury_login WITH PASSWORD = '111';
CREATE LOGIN Appel_login WITH PASSWORD = '222';

GRANT SELECT ON Tournament TO AppelJury;
GRANT SELECT ON TeamTournament TO AppelJury;
GRANT SELECT ON GameRound TO AppelJury;
GRANT SELECT ON Team TO AppelJury;
GRANT SELECT ON Address TO AppelJury;

CREATE USER TestJury FOR LOGIN Jury_login;
CREATE USER TestAppelJury FOR LOGIN Appel_login;

EXEC sp_addrolemember @rolename = 'Jury', @membername = 'TestJury';
EXEC sp_addrolemember @rolename = 'AppelJury', @membername = 'TestAppelJury';
