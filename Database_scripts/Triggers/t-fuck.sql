GO

IF OBJECT_ID ('T_Tournament', 'TR') IS NOT NULL
   DROP TRIGGER T_Tournament;
GO
CREATE TRIGGER T_Tournament
	ON Tournament
	INSTEAD OF UPDATE
AS
	DECLARE @att_id1 INT;
	SET @att_id1 = (SELECT id FROM EntityAttributeDict WHERE name='Tournament.name')
	if (@att_id1 IS NULL)
		raiserror('No such historical entry! (Tournament.name)', 18, -1);	

	DECLARE @att_id2 INT;
	SET @att_id2 = (SELECT id FROM EntityAttributeDict WHERE name='Tournament.address_id')
	if (@att_id2 IS NULL)
		raiserror('No such historical entry! (Tournament.address_id)', 18, -1);

	DECLARE @att_id3 INT;
	SET @att_id3 = (SELECT id FROM EntityAttributeDict WHERE name='Tournament.password')
	if (@att_id3 IS NULL)
		raiserror('No such historical entry! (Tournament.password)', 18, -1);

	DECLARE @test NVARCHAR(max)

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id1, GETDATE(), deleted.name FROM inserted, deleted
		WHERE inserted.name != deleted.name
		AND inserted.name IS NOT NULL
		AND inserted.name != ''
		AND inserted.id = deleted.id

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id2, GETDATE(), deleted.address_id FROM inserted, deleted
		WHERE inserted.address_id != deleted.address_id
		AND inserted.id = deleted.id

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id3, GETDATE(), deleted.password FROM inserted, deleted
		WHERE inserted.password != deleted.password
		AND inserted.password IS NOT NULL
		AND inserted.password != ''
		AND inserted.id = deleted.id


	UPDATE Tournament SET Tournament.name = inserted.name 
	FROM Tournament, inserted, deleted
		WHERE inserted.name != deleted.name
		AND inserted.id = deleted.id
		AND inserted.name IS NOT NULL
		AND inserted.name != ''
		AND Tournament.id = inserted.id

	UPDATE Tournament SET Tournament.address_id = tmp.address_id 
	FROM
		Tournament
	INNER JOIN
		(SELECT inserted.id, inserted.address_id FROM inserted, deleted
		WHERE inserted.address_id != deleted.address_id
		AND inserted.id = deleted.id) tmp
	ON Tournament.id = tmp.id

	UPDATE Tournament SET Tournament.password = tmp.password 
	FROM
		Tournament
	INNER JOIN
		(SELECT inserted.id, inserted.password FROM inserted, deleted
		WHERE inserted.password != deleted.password
		AND inserted.id = deleted.id	
		AND inserted.password IS NOT NULL
		AND inserted.password != '') tmp
	ON Tournament.id = tmp.id

GO
