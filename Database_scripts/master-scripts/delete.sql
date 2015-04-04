USE [kbt-project];

DROP PROCEDURE addTeam;
DROP PROCEDURE addPlayer;
DROP PROCEDURE addTournament;
DROP PROCEDURE addTeam2Tournament;
DROP PROCEDURE addPlayer2Season;
DROP PROCEDURE addGameRound;
DROP PROCEDURE addAnswer;
DROP PROCEDURE addPlayer2GameRound;
DROP PROCEDURE addAnswerByGlobalID;
DROP PROCEDURE addAgeCategory2TeamTournament;
DROP PROCEDURE addAttribute2Dict;

DROP TABLE AgeCategory;
DROP TABLE ExternalT;
DROP TABLE History;
DROP TABLE EntityAttributeDict;
DROP TABLE PlayerSeason;
DROP TABLE PlayerTeamGameround;
DROP TABLE TeamTournament;
DROP TABLE Answer;
DROP TABLE Question;
DROP TABLE GameRound;
DROP TABLE Tournament;
DROP TABLE Season;
ALTER TABLE Team
	DROP CONSTRAINT FK_Team_Captain;
DROP TABLE Player;
DROP TABLE Team;
DROP TABLE Address;
DROP TABLE AddressType;