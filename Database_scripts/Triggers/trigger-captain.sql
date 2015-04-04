GO
IF OBJECT_ID ('T_Team_captain_id', 'TR') IS NOT NULL
   DROP TRIGGER T_Team_captain_id;
GO
CREATE TRIGGER T_Team_captain_id
	ON Team
	AFTER UPDATE
AS
	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Team.captain_id')
	IF (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.captain_id
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.captain_id != inserted.captain_id
		AND inserted.captain_id != ''
		AND inserted.captain_id IS NOT NULL;
GO