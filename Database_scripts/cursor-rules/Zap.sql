DECLARE @i int = 1
WHILE @i < 200 BEGIN
    SET @i = @i + 1
	INSERT INTO Tournament(address_id, season_id, name, password) VALUES (1, 1, @i, @i)
END