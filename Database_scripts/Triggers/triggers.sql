GO
IF OBJECT_ID ('T_Answer_is_valid', 'TR') IS NOT NULL
   DROP TRIGGER T_Answer_is_valid;
GO
CREATE TRIGGER T_Answer_is_valid
	ON Answer
	INSTEAD OF UPDATE
AS
	DECLARE @id INT, @is_valid BIT;
	DECLARE @id_ INT, @is_valid_ BIT;
	
	DECLARE CUR2 CURSOR FOR
		SELECT id, is_valid FROM deleted
	DECLARE CUR1 CURSOR FOR
		SELECT id, is_valid FROM inserted

	DECLARE @att_id1 INT;
	SET @att_id1 = (SELECT id FROM EntityAttributeDict WHERE 		name='Answer.is_valid')
	IF (@att_id1 IS NULL)
		raiserror('No such historical entry!', 18, -1);

	OPEN CUR1;
	OPEN CUR2;
	
	FETCH NEXT FROM CUR1 INTO @id, @is_valid;
	FETCH NEXT FROM CUR2 INTO @id_, @is_valid_;	
		
	WHILE @@FETCH_STATUS=0
	BEGIN
		
		IF @is_valid IS NOT NULL AND @is_valid != @is_valid_
			BEGIN
				UPDATE Answer SET is_valid = @is_valid WHERE id = @id;
				INSERT INTO History(instance_id, attribute_id, modification_date, previous_value)
					VALUES(@id, @att_id1, GETDATE(), @is_valid)
			END
			
		FETCH NEXT FROM CUR1 INTO @id, @is_valid;
		FETCH NEXT FROM CUR2 INTO @id_, @is_valid_;
	END
		
	CLOSE CUR1;
	CLOSE CUR2;
	DEALLOCATE CUR1;
	DEALLOCATE CUR2;
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
	INSTEAD OF UPDATE
AS
	DECLARE @att_id INT;
		SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Team.phone')
		if (@att_id IS NULL)
			raiserror('No such historical entry!', 18, -1);
	
	DECLARE CUR_INFO CURSOR FOR
		SELECT inserted.id, inserted.phone, deleted.phone FROM inserted, deleted
			WHERE inserted.id = deleted.id;

	
	DECLARE @cur NVARCHAR(max), @prev NVARCHAR(max), @id INT;

	OPEN CUR_INFO;

	FETCH NEXT FROM CUR_INFO INTO @id, @cur, @prev

	WHILE @@FETCH_STATUS=0
	BEGIN
		--PRINT 'Here?'
		--PRINT @cur
		--PRINT @prev
		IF(@cur != '' AND @cur != ISNULL(@prev, ''))
		BEGIN
			--PRINT 'Here!'
			UPDATE Team SET phone = @cur WHERE id = @id;

			INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
				VALUES (@id, @att_id, GETDATE(), @prev)
		END
		FETCH NEXT FROM CUR_INFO INTO @id, @cur, @prev
	END
	
	CLOSE CUR_INFO
	DEALLOCATE CUR_INFO
	-------
		--DECLARE @att_id INT;
		SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Team.email')
		if (@att_id IS NULL)
			raiserror('No such historical entry!', 18, -1);
	
	DECLARE CUR_INFO CURSOR FOR
		SELECT inserted.id, inserted.email, deleted.email FROM inserted, deleted
			WHERE inserted.id = deleted.id;

	
	--DECLARE @cur NVARCHAR(max),@prev NVARCHAR(max), @id INT;

	OPEN CUR_INFO;

	FETCH NEXT FROM CUR_INFO INTO @id, @cur, @prev

	WHILE @@FETCH_STATUS=0
	BEGIN
		--PRINT 'Here?'
		--PRINT @cur
		--PRINT @prev
		IF(@cur != '' AND @cur != ISNULL(@prev, ''))
		BEGIN
			--PRINT 'Here!'
			UPDATE Team SET email = @cur WHERE id = @id;

			INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
				VALUES (@id, @att_id, GETDATE(), @prev)
		END
		FETCH NEXT FROM CUR_INFO INTO @id, @cur, @prev
	END
	
	CLOSE CUR_INFO
	DEALLOCATE CUR_INFO
GO

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


IF OBJECT_ID ('T_Team_Email', 'TR') IS NOT NULL
   DROP TRIGGER T_Team_Email;
GO
