GO
IF OBJECT_ID ('T_Answer_is_valid', 'TR') IS NOT NULL
   DROP TRIGGER T_Answer_is_valid;
GO
CREATE TRIGGER T_Answer_is_valid
	ON Answer
	AFTER UPDATE
AS
	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Answer.is_valid')
	IF (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.is_valid
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.is_valid != inserted.is_valid
		AND inserted.is_valid IS NOT NULL;
GO