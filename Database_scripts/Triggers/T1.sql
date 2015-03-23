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

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.name
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.name != inserted.name
GO

GO
IF OBJECT_ID ('T_Tournament', 'TR') IS NOT NULL
   DROP TRIGGER T_Tournament;
GO
CREATE TRIGGER T_Tournament
	ON Tournament
	AFTER UPDATE
AS
	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Tournament.name')
	if (@att_id IS NULL)
		raiserror('No such historical entry! (Tournament.name)', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.name
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.name != inserted.name

	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Tournament.address_id')
	if (@att_id IS NULL)
		raiserror('No such historical entry! (Tournament.address_id)', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.address_id
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.address_id != inserted.address_id

	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Tournament.password')
	if (@att_id IS NULL)
		raiserror('No such historical entry! (Tournament.password)', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.password
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.password != inserted.password
GO

