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
IF OBJECT_ID ('T_Team_email', 'TR') IS NOT NULL
   DROP TRIGGER T_Team_email;
GO
CREATE TRIGGER T_Team_email
	ON Team
	AFTER UPDATE
AS
	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Team.email')
	IF (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);

	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value)
		SELECT deleted.id, @att_id, GETDATE(), deleted.email
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.email != inserted.email
		AND inserted.email != ''
		AND inserted.email IS NOT NULL;

	DECLARE @prev NVARCHAR(max);
	SET @prev = (SELECT deleted.email FROM deleted, inserted WHERE deleted.id = inserted.id);

	DECLARE @cur NVARCHAR(max);
	SET @cur = (SELECT inserted.email FROM deleted, inserted WHERE inserted.id = deleted.id);

	DECLARE @id INT;
	SET @id = (SELECT inserted.id FROM deleted, inserted WHERE inserted.id = deleted.id);

	IF((@cur IS NULL OR @cur = '') AND @prev IS NOT NULL AND @prev != '')
		UPDATE Team
		SET email = @prev
		WHERE id = @id;
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
		PRINT 'Here?'
		PRINT @cur
		PRINT @prev
		IF(@cur != '' AND @cur != ISNULL(@prev, ''))
		BEGIN
			PRINT 'Here!'
			UPDATE Team SET phone = @cur WHERE id = @id;

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
	DECLARE @i  INT, @name  NVARCHAR(max), @addr  INT, @pass  NVARCHAR(max);
	DECLARE @i_ INT, @name_ NVARCHAR(max), @addr_ INT, @pass_ NVARCHAR(max);

	DECLARE CUR1 CURSOR FOR
	SELECT id, name, address_id, password FROM deleted
	DECLARE CUR2 CURSOR FOR
	SELECT id, name, address_id, password FROM inserted

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

	OPEN CUR1
	OPEN CUR2
	WHILE @@FETCH_STATUS=0
	BEGIN
		FETCH NEXT FROM CUR1 INTO @i, @name, @addr, @pass;
		FETCH NEXT FROM CUR2 INTO @i_, @name_, @addr_, @pass_;

		IF @name != '' AND @name != @name_
		BEGIN
			UPDATE Tournament SET name = @name WHERE id = @i;
			INSERT INTO History(instance_id, attribute_id, modification_date, previous_value)
				VALUES (@i, @att_id1, GETDATE(), @name)
		END

		IF @addr != '' AND @addr != @addr_
		BEGIN
			UPDATE Tournament SET address_id = @addr WHERE id = @i;
			INSERT INTO History(instance_id, attribute_id, modification_date, previous_value)
				VALUES (@i, @att_id2, GETDATE(), @addr)
		END

		IF @pass != '' AND @pass != @pass_
		BEGIN
			UPDATE Tournament SET password = @pass WHERE id = @i;
			INSERT INTO History(instance_id, attribute_id, modification_date, previous_value)
				VALUES (@i, @att_id2, GETDATE(), @addr)
		END

		FETCH NEXT FROM CUR1 INTO @i, @name, @addr, @pass;
		FETCH NEXT FROM CUR2 INTO @i_, @name_, @addr_, @pass_;
	END
	CLOSE CUR1
	CLOSE CUR2
	DEALLOCATE CUR1
	DEALLOCATE CUR2
GO
