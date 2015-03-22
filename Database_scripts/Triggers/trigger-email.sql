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