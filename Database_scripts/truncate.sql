DELETE FROM AgeCategory;
DELETE FROM ExternalT;
DELETE FROM History;
DELETE FROM AttributeDict;
DELETE FROM EntityDict;
DELETE FROM PlayerSeason;
DELETE FROM PlayerTeamGameround;
DELETE FROM TeamTournament;
DELETE FROM Answer;
DELETE FROM Question;
DELETE FROM GameRound;
DELETE FROM Tournament;
DELETE FROM Season;
ALTER TABLE Team
	DROP CONSTRAINT FK_Team_Captain;
DELETE FROM Player;
DELETE FROM Team;
ALTER TABLE Team
	ADD CONSTRAINT FK_Team_Captain FOREIGN KEY (captain_id)
		REFERENCES Player(id);
DELETE FROM Address;
DELETE FROM AddressType;

INSERT INTO AddressType (name) VALUES ('City');
