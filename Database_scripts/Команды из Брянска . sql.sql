-- ответы комманд из Брянска, с укащанием полной читаемой информации о турнире, в котором они были даны
IF OBJECT_ID ('Answers_of_Team', 'V') IS NOT NULL
DROP VIEW Answers_of_Team;
GO
CREATE VIEW Answers_of_Team AS
	SELECT Team.name 'Команда из Брянска', Tournament.name as 'Название турнира', Tournament.season_id as 'Сезон', 
			adr_tournament.name as 'Место проведения', Answer.question_num as 'Номер вопроса', Answer.answer_text as 'Ответ', Answer.is_valid as 'Верный?'
		FROM Team, Answer, "Address" as adr_team, GameRound, Tournament, "Address" as adr_tournament
 		WHERE Answer.team_id = Team.id AND Team.address_id = adr_team.id AND Answer.gameround_id = GameRound.id 
		AND GameRound.tournament_id = Tournament.id AND adr_team.name = 'Брянск' AND Tournament.address_id = adr_tournament.id
GO

-- игроки команд из Брянска, которым не исполнилось 18 лет
IF OBJECT_ID ('Players_of_Team', 'V') IS NOT NULL
DROP VIEW Players_of_Team;
GO
CREATE VIEW Players_of_Team AS
	SELECT Team.name 'Команда из Брянска', Tournament.name as 'Название турнира',
				Tournament.season_id as 'Сезон',  adr_tournament.name as 'Место проведения',
				Player.name as 'Имя', Player.birthday, DATEDIFF(YEAR,  Player.birthday, Season.begin_date) as 'Возраст на момент турнира'
		FROM Player, Team, "Address" as adr_team, TeamTournament, Tournament, "Address" as adr_tournament, Season
 		WHERE Player.team_id = Team.id AND Team.address_id = adr_team.id AND adr_team.name = 'Долгопрудный'
		AND Team.id = TeamTournament.team_id AND TeamTournament.tournament_id = Tournament.id AND adr_tournament.id = Tournament.address_id
		AND Season.id = Tournament.season_id AND DATEDIFF(YEAR, Player.birthday, Season.begin_date) < 18
GO


SELECT *
FROM Players_of_Team
ORDER BY  Players_of_Team.[Команда из Брянска]
