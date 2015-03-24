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

