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
GO

