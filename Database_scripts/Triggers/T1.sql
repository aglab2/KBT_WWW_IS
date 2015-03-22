GO
IF OBJECT_ID ('T_Address_name', 'TR') IS NOT NULL
   DROP TRIGGER T_Address_name;
GO
CREATE TRIGGER T_Address_name
	ON Address
	AFTER UPDATE
AS
	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Address.name')
	if (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date,gameround_id,previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), 1, deleted.name
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.name != inserted.name
GO