-- id команды у участника + телефон у команды

IF OBJECT_ID ('T_Player_Team_ID', 'TR') IS NOT NULL
   DROP TRIGGER T_Player_Team_ID;
GO

CREATE TRIGGER T_Player_Team_ID
	ON Player
	AFTER UPDATE
AS
	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Player.team_id')
	if (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.team_id
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.team_id != inserted.team_id
GO

IF OBJECT_ID ('T_Team_Phone', 'TR') IS NOT NULL
   DROP TRIGGER T_Team_Phone;
GO

CREATE TRIGGER T_Team_Phone
	ON Team
	AFTER UPDATE
AS
	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Team.phone')
	if (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.phone
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.phone != inserted.phone
		AND inserted.phone != ''
		AND inserted.phone IS NOT NULL
GO

SELECT *
FROM EntityAttributeDict, History
WHERE EntityAttributeDict.id = History.attribute_id
ORDER BY History.instance_id