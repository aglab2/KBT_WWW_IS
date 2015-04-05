DECLARE @i int;
SET @i = 1;
WHILE @i < 2000 BEGIN
    SET @i = @i + 1
	UPDATE Tournament SET name=@i-id WHERE 1=1
END