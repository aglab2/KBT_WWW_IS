USE [kbt-project];

INSERT INTO AddressType (name) VALUES ('City');
GO

CREATE PROCEDURE addTournament
	@city NVARCHAR(max),
	@name NVARCHAR(max),
	@password NVARCHAR(max),
	@season INT = NULL
AS
	DECLARE @city_id INT;
	SET @city_id = (SELECT id FROM Address WHERE name = @city);
	IF @city_id IS NULL
	BEGIN
		DECLARE @city_type_id INT;
		SET @city_type_id = (SELECT id FROM AddressType WHERE name = 'City');
		INSERT INTO Address (type_id, name) VALUES (@city_type_id, @city);
		SET @city_id = IDENT_CURRENT('Address');
	END	
	DECLARE @year INT;
	DECLARE @curseason datetime;
	IF @season IS NULL
	BEGIN
		SET @year = (SELECT YEAR(CURRENT_TIMESTAMP) - 1970);
		SET @curseason = DATEADD(year, @year, '01-09-1970');
		IF DATEDIFF(day, @curseason, CURRENT_TIMESTAMP) < 0
		BEGIN
			SET @curseason = DATEADD(year, -1, @curseason);
		END
	END
	ELSE
	BEGIN
		SET @year = @season - 1970;
		SET @curseason = DATEADD(year, @year, '01-09-1970');
	END 
	
	DECLARE @curendseason datetime;
	SET @curendseason = DATEADD(day, -1, @curseason);
	SET @curendseason = DATEADD(year, 1, @curendseason);
	DECLARE @season_id INT;
	SET @season_id = (SELECT id FROM Season WHERE begin_date = @curseason);
	IF @season_id IS NULL
	BEGIN
		INSERT INTO Season(begin_date, end_date) VALUES (@curseason, @curendseason);
		SET @season_id = IDENT_CURRENT('Season');
	END

	DECLARE @id INT;
	SET @id = (SELECT id FROM Tournament WHERE name = @name);
	IF @id IS NULL
	BEGIN 
		INSERT INTO Tournament(name, address_id, password, season_id) VALUES (@name, @city_id, @password, @season_id);
	END
	ELSE
	BEGIN
		UPDATE Tournament SET name = @name, address_id = @city_id, password = @password, season_id = @season_id WHERE id = @id;
	END
GO

CREATE PROCEDURE addTeam
	@name NVARCHAR(max),
	@phone NVARCHAR(max) = NULL,
	@email NVARCHAR(max) = NULL,
	@city NVARCHAR(max)
AS
	DECLARE @city_id INT;
	SET @city_id = (SELECT id FROM Address WHERE name = @city);
	IF @city_id IS NULL
	BEGIN
		DECLARE @city_type_id INT;
		SET @city_type_id = (SELECT id FROM AddressType WHERE name = 'City');
		INSERT INTO Address (type_id, name) VALUES (@city_type_id, @city);
		SET @city_id = (SELECT id FROM Address WHERE name = @city);
	END

	DECLARE @id INT;
	SET @id = (SELECT id FROM Team WHERE name = @name);
	IF @id IS NULL
	BEGIN 
		INSERT INTO Team(name, phone, email, address_id, captain_id) VALUES (@name, @phone, @email, @city_id, NULL);
	END
	ELSE
	BEGIN
		UPDATE Team SET captain_id = NULL, name = @name, phone = @phone, address_id = @city_id, email = @email WHERE id = @id
		/*History*/
	END
GO


CREATE PROCEDURE addAgeCategory2TeamTournament
	@team_name NVARCHAR(max),
	@tournament_name NVARCHAR(max),
	@tournament_city NVARCHAR(max),
	@age_category NVARCHAR(max)
AS
	DECLARE @city_id INT;
	SET @city_id = (SELECT id FROM Address WHERE name = @tournament_city);
	IF @city_id IS NULL
		raiserror('No such city!', 20, -1);

	DECLARE @team_id INT;
	SET @team_id = (SELECT id FROM Team WHERE name = @team_name);
	IF @team_id IS NULL
		raiserror('No such team!', 18, -1);/*I like magical constants*/

	DECLARE @tournament_id INT;
	SET @tournament_id = (SELECT id FROM Tournament WHERE name = @tournament_name AND address_id = @city_id);	
	IF @tournament_id IS NULL
		raiserror('No such tournament!', 18, -1);

	DECLARE @age_category_id INT;
	SET @age_category_id = (SELECT id FROM AgeCategory WHERE AgeCategory.name = @age_category)
	IF @age_category_id IS NULL
	BEGIN
		INSERT INTO AgeCategory(clgroup, name) VALUES (0, @age_category) --what the hell clgroup?
		SET @age_category_id = IDENT_CURRENT('AgeCategory');
	END

	DECLARE @age_category_cur NVARCHAR(max);
	SET @age_category_cur = (SELECT age_category_id FROM TeamTournament WHERE team_id=@team_id AND tournament_id=@tournament_id)
	IF @age_category_cur IS NULL
		raiserror('No such team in tournament!', 18, -1);

	SET @age_category_cur = @age_category_cur | POWER(2, @age_category_id - 1);

	UPDATE TeamTournament SET age_category_id = @age_category_cur WHERE team_id=@team_id AND tournament_id=@tournament_id;
GO


CREATE PROCEDURE addTeam2Tournament
	@team_name NVARCHAR(max),
	@tournament_name NVARCHAR(max),
	@tournament_city NVARCHAR(max),
	@regcard_number NVARCHAR(max)
AS
	DECLARE @city_id INT;
	SET @city_id = (SELECT id FROM Address WHERE name = @tournament_city);
	IF @city_id IS NULL
		raiserror('No such city!', 20, -1);

	DECLARE @team_id INT;
	SET @team_id = (SELECT id FROM Team WHERE name = @team_name);
	IF @team_id IS NULL
		raiserror('No such team!', 18, -1);/*I like magical constants*/

	DECLARE @tournament_id INT;
	SET @tournament_id = (SELECT id FROM Tournament WHERE name = @tournament_name AND address_id = @city_id);	
	IF @tournament_id IS NULL
		raiserror('No such tournament!', 18, -1);

	DECLARE @id NVARCHAR(max);
	SET @id = (SELECT regcard_number FROM TeamTournament WHERE team_id=@team_id AND tournament_id=@tournament_id)

	IF @id IS NULL
	BEGIN
		INSERT INTO TeamTournament(team_id, tournament_id, regcard_number, age_category_id) VALUES (@team_id, @tournament_id, @regcard_number, 0);
	END
	ELSE
	BEGIN
		UPDATE TeamTournament SET regcard_number = @regcard_number WHERE team_id=@team_id AND tournament_id=@tournament_id;
		/*History*/
	END
GO

CREATE PROCEDURE addPlayer
	@rate_id INTEGER = NULL,
	@team_name NVARCHAR(max) = NULL,
	@name NVARCHAR(max),
	@birthday SMALLDATETIME = NULL,
	@is_captain BIT = 0,
	@is_legioner BIT = 0
AS
	DECLARE @player_id INT;
	IF @birthday IS NULL
		SET @player_id = (SELECT id FROM Player WHERE name = @name AND birthday IS NULL);
	ELSE
		SET @player_id = (SELECT id FROM Player WHERE name = @name AND birthday = @birthday); 

	DECLARE @team_id INT;
	IF @is_legioner = 0 --not legioner
	BEGIN
		SET @team_id = (SELECT id FROM Team WHERE name = @team_name);
		IF @team_id IS NULL
			raiserror('No such team!', 18, -1)
	END
	ELSE 
		SET @team_id = NULL;

	IF @player_id IS NULL
		BEGIN
			INSERT INTO Player(team_id, name, birthday) VALUES (@team_id, @name, @birthday);
		END
	ELSE
		BEGIN
			UPDATE Player SET birthday = @birthday WHERE id = @player_id;
		END

	IF @is_captain = 1
	BEGIN
		IF @birthday IS NULL
			SET @player_id = (SELECT id FROM Player WHERE name = @name AND birthday IS NULL);
		ELSE
			SET @player_id = (SELECT id FROM Player WHERE name = @name AND birthday = @birthday); 
		UPDATE Team SET captain_id = @player_id WHERE id = @team_id;
	END
	
GO

CREATE PROCEDURE addPlayer2Season
	@player_name NVARCHAR(max),
	@player_birthday SMALLDATETIME = NULL,
	@season_year INT = NULL,
	@schoolgrade INT = 0
AS
	DECLARE @startdate SMALLDATETIME;
	DECLARE @enddate SMALLDATETIME;
	SET @startdate = '1970-01-09';
	SET @enddate = '1971-31-08';
	IF @season_year IS NULL
	BEGIN
		SET @startdate = DATEADD(year,year(CURRENT_TIMESTAMP)-1970,@startdate);
		SET @enddate = DATEADD(year,year(CURRENT_TIMESTAMP)-1970,@enddate);
	END
	ELSE
	BEGIN
		SET @startdate = DATEADD(year,@season_year-1970,@startdate);
		SET @enddate = DATEADD(year,@season_year-1970,@enddate);
	END

	IF DATEDIFF(day, @startdate, CURRENT_TIMESTAMP) < 0
	BEGIN
		SET @startdate = DATEADD(year,-1,@startdate);
		SET @enddate = DATEADD(year,-1,@enddate);
	END

	DECLARE @season_id INT;
	SET @season_id = (SELECT id FROM Season WHERE begin_date = @startdate AND end_date = @enddate);
	IF @season_id IS NULL
	BEGIN
		INSERT INTO Season (begin_date, end_date) VALUES (@startdate, @enddate)
		SET @season_id = IDENT_CURRENT('Season');
	END

	DECLARE @player_id INT;
	IF @player_birthday IS NULL
		SET @player_id = (SELECT id FROM Player WHERE name = @player_name AND birthday IS NULL);
	ELSE
		SET @player_id = (SELECT id FROM Player WHERE name = @player_name AND birthday = @player_birthday); 

	IF @player_id IS NULL
		raiserror('No such player', 18, -1);

	DECLARE @id INT;
	SET @id = (SELECT schoolgrade FROM PlayerSeason WHERE player_id=@player_id AND season_id=@season_id)

	IF @id IS NULL
	BEGIN
		INSERT INTO PlayerSeason(player_id, season_id, schoolgrade) VALUES (@player_id, @season_id, @schoolgrade);
		/*Age category*/
	END
	ELSE
	BEGIN
		UPDATE PlayerSeason SET schoolgrade=@schoolgrade WHERE player_id=@player_id AND season_id=@season_id;
		/*History*/
	END
GO

CREATE PROCEDURE addGameRound
	@gamenumber INT,
	@city NVARCHAR(MAX),
	@tournament_name NVARCHAR(MAX)
AS
	DECLARE @city_id INT;
	SET @city_id = (SELECT id FROM Address WHERE name = @city);
	DECLARE @tournament_id INT;
	SET @tournament_id = (SELECT id FROM Tournament WHERE name = @tournament_name AND address_id = @city_id);
	DECLARE @gameround_id INT;
	SET @gameround_id = (SELECT id FROM GameRound WHERE tournament_id = @tournament_id AND gamenumber = @gamenumber);
	IF @gameround_id IS NULL
	BEGIN
		INSERT INTO GameRound(tournament_id, gamenumber) VALUES (@tournament_id, @gamenumber);
	END
GO

CREATE PROCEDURE addAnswer 
	@team_name NVARCHAR(MAX),
	@question_num INT,
	@answer_text NVARCHAR(MAX),
	@is_valid BIT = NULL,
	@tournament_name NVARCHAR(MAX),
	@city NVARCHAR(MAX),
	@gamenumber INT
AS
	DECLARE @team_id INT;
	SET @team_id = (SELECT id FROM Team WHERE name = @team_name);
	IF @team_id IS NULL
		raiserror('No such team', 18, -1);
	DECLARE @tournament_id INT;
	DECLARE @city_id INT;
	SET @city_id = (SELECT id FROM Address WHERE name = @city);
	IF @city_id IS NULL
		raiserror('No such city', 18, -1);
	SET @tournament_id = (SELECT id FROM Tournament WHERE name = @tournament_name AND address_id = @city_id);
	IF @tournament_id IS NULL
		raiserror('No such tournament', 18, -1);
	DECLARE @gameround_id INT;
	SET @gameround_id = (SELECT id FROM GameRound WHERE gamenumber = @gamenumber AND tournament_id = @tournament_id);
	IF @gameround_id IS NULL
		raiserror('No such gameround', 18, -1);
	DECLARE @answer_id INT;
	SET @answer_id = (SELECT gameround_id FROM Answer WHERE gameround_id = @gameround_id AND team_id = @team_id AND question_num = @question_num );
	IF @answer_id IS NULL
	BEGIN
		INSERT Answer (gameround_id, team_id, question_id, question_num, answer_text, is_valid) VALUES (@gameround_id, @team_id, NULL, @question_num, @answer_text, @is_valid);
	END
GO


/* процедура добавления игрока в тур. Не существующий тур создается */
/* Требуется: созданный игрок, созданная команда, созданный город, созданный турнир */
CREATE PROCEDURE addPlayer2GameRound
	@player_name NVARCHAR(max),
	@player_birthday SMALLDATETIME = NULL,
	@player_team_name NVARCHAR(max) = NULL,
	@tour_number INTEGER,
	@tournament_name NVARCHAR(max),
	@tournament_city NVARCHAR(max),
	@is_legioner BIT = 0
AS
	-- получаем ID игрока 
	DECLARE @player_id INT;
	IF @player_birthday IS NULL
		SET @player_id = (SELECT id FROM Player WHERE name = @player_name);
	ELSE
		SET @player_id = (SELECT id FROM Player WHERE name = @player_name AND birthday = @player_birthday)
	IF @player_id IS NULL
		raiserror('No such player', 18, -1);

		
	-- получаем ID города
	DECLARE @city_id INT;
	SET @city_id = (SELECT id FROM Address WHERE name = @tournament_city);
	IF @city_id IS NULL
		raiserror('No such city', 18, -1);


	-- получаем ID турнира
	DECLARE @tournament_id INT;
	SET @tournament_id = (SELECT id FROM Tournament WHERE name = @tournament_name AND address_id = @city_id);
	IF @tournament_id IS NULL
		raiserror('No such tournament', 18, -1);


	-- поиск/создание! тура
	DECLARE @gameround_id INT;
	SET @gameround_id = (SELECT id FROM GameRound WHERE tournament_id = @tournament_id AND gamenumber = @tour_number);
	IF @gameround_id IS NULL
	BEGIN
		INSERT INTO GameRound(tournament_id, gamenumber) VALUES (@tournament_id, @tour_number);
	END
	SET @gameround_id = (SELECT id FROM GameRound WHERE tournament_id = @tournament_id AND gamenumber = @tour_number);


	
	-- получаем ID команды
	DECLARE @player_team_id INT;
	SET @player_team_id = (SELECT id FROM Team WHERE name = @player_team_name)
	IF @player_team_id IS NULL
		raiserror('No such team', 18, -1);


	-- создаем связь между игроком, командой и туром
	DECLARE @event_node INT;
	SET @event_node = (SELECT player_id FROM PlayerTeamGameround WHERE player_id=@player_id AND gameround_id=@gameround_id AND team_id=@player_team_id)
	
	IF @event_node IS NULL
		INSERT INTO PlayerTeamGameround(player_id, gameround_id, team_id) VALUES (@player_id, @gameround_id, @player_team_id);
	
	IF @is_legioner = 0
	BEGIN
		UPDATE Player
		SET Player.team_id = @player_team_id
		WHERE Player.id = @player_id
	END
GO

/* Процедура добавления ответа команды на вопрос по ее внешнему ID */
/* Требуется: Созданный турнир, созданная команда, созданный город,  */
CREATE PROCEDURE addAnswerByGlobalID 
	@regcard_number nvarchar(max),
	@question_num INT,
	@answer_text NVARCHAR(MAX),
	@is_valid BIT,
	@tournament_name NVARCHAR(max),
	@tournament_city NVARCHAR(max),
	@gamenumber INT
AS
	DECLARE @city_id INT;
	SET @city_id = (SELECT id FROM Address WHERE name = @tournament_city);
	IF @city_id IS NULL
		raiserror('No such city', 18, -1);

	DECLARE @tournament_id INT;
	SET @tournament_id = (SELECT id FROM Tournament WHERE name = @tournament_name AND address_id = @city_id);
	IF @tournament_id IS NULL
		raiserror('No such tournament', 18, -1);

	
	DECLARE @team_id INT;
	SET @team_id = (SELECT team_id FROM TeamTournament WHERE tournament_id = @tournament_id AND regcard_number = @regcard_number);
	IF @team_id IS NULL
		raiserror('No team with such code', 18, -1);
	

	DECLARE @gameround_id INT;
	SET @gameround_id = (SELECT id FROM GameRound WHERE gamenumber = @gamenumber AND tournament_id = @tournament_id);
	IF @gameround_id IS NULL
		raiserror('No such gameround', 18, -1);


	DECLARE @answer_id INT;
	SET @answer_id = (SELECT gameround_id FROM Answer WHERE gameround_id = @gameround_id AND team_id = @team_id AND question_num = @question_num );
	IF @answer_id IS NULL
	BEGIN
		INSERT Answer (gameround_id, team_id, question_id, question_num, answer_text, is_valid) VALUES (@gameround_id, @team_id, NULL, @question_num, @answer_text, @is_valid);
	END
GO

CREATE PROCEDURE addAttribute2Dict
	@entity_name nvarchar(max) = '',
	@attribute_name nvarchar(max) = ''
AS
	DECLARE @fullname nvarchar(max);
	SET @fullname = @entity_name + '.' + @attribute_name;
	INSERT INTO EntityAttributeDict(name) VALUES (@fullname);
GO