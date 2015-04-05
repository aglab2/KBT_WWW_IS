DECLARE @i int = 0
WHILE @i < 200 BEGIN
    SET @i = @i + 1
	UPDATE Tournament SET name=@i-id WHERE 1=1
END