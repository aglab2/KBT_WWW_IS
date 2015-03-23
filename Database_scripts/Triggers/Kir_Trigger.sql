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
	DECLARE @prev NVARCHAR(max);	
	SET @prev = (SELECT deleted.phone FROM deleted, inserted WHERE deleted.id = inserted.id);
	
	DECLARE @cur NVARCHAR(max);
	SET @cur = (SELECT inserted.phone FROM deleted, inserted WHERE inserted.id = deleted.id);
	
	DECLARE @id INT;
	SET @id = (SELECT inserted.id FROM deleted, inserted WHERE inserted.id = deleted.id);
	
	IF(@cur IS NOT NULL AND @cur != '' AND @cur != @prev)
	BEGIN
		UPDATE Team SET phone = @cur WHERE id = @id;

		DECLARE @att_id INT;
		SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Team.phone')
		if (@att_id IS NULL)
			raiserror('No such historical entry!', 18, -1);

		INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.phone
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.phone != inserted.phone
	END
GO