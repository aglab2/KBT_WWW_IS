GO
IF OBJECT_ID ('T_Answer_is_valid', 'TR') IS NOT NULL
   DROP TRIGGER T_Answer_is_valid;
GO
CREATE TRIGGER T_Answer_is_valid
	ON Answer
	AFTER UPDATE
AS
	DECLARE @id INT, @is_valid BIT;

	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Answer.is_valid')
	IF (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);
	
	UPDATE Answer
		SET Answer.is_valid = deleted.is_valid
		FROM deleted, inserted, Answer
		WHERE deleted.id = inserted.id AND deleted.id = Answer.id AND
		deleted.is_valid IS NOT NULL AND inserted.is_valid IS NULL;
		
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

IF OBJECT_ID ('T_Team', 'TR') IS NOT NULL
   DROP TRIGGER T_Team;
GO

CREATE TRIGGER T_Team
	ON Team
	AFTER UPDATE
AS
	DECLARE @att_id INT;
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Team.phone')
	IF (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);
			
	UPDATE Team
		SET Team.phone = deleted.phone
		FROM deleted, inserted
		WHERE Team.id = deleted.id AND Team.id = inserted.id AND deleted.phone IS NOT NULL AND deleted.phone != ''
		AND (inserted.phone IS NULL OR inserted.phone = '');
		
	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.phone
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.phone != inserted.phone
		AND inserted.phone IS NOT NULL
		AND inserted.phone != '';
		
	SET @att_id = (SELECT id FROM EntityAttributeDict WHERE name='Team.email')
	IF (@att_id IS NULL)
		raiserror('No such historical entry!', 18, -1);
			
	UPDATE Team
		SET Team.email = deleted.email
		FROM deleted, inserted
		WHERE Team.id = deleted.id AND Team.id = inserted.id AND deleted.email IS NOT NULL AND deleted.email != ''
		AND (inserted.email IS NULL OR inserted.email = '');
		
	INSERT INTO History(instance_id, attribute_id, modification_date, previous_value) 
		SELECT deleted.id, @att_id, GETDATE(), deleted.email
		FROM deleted, inserted
		WHERE deleted.id = inserted.id
		AND deleted.email != inserted.email
		AND inserted.email IS NOT NULL
		AND inserted.email != '';
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
