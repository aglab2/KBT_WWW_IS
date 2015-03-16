CREATE PROCEDURE DeleteTeam
	@teamname NVARCHAR(max)
AS
	DELETE FROM Team
	WHERE Team.name = @teamname
GO


exec addTournament @city='Москва',@name='14 Чемпионат МО по ЧГК.',@password='fi9QT3HR6'
exec addTeam @name='Игугундер',@phone='',@email='lolopoolik@yandex.ru',@city='Долгопрудный'
exec addTeam2Tournament @team_name='Игугундер',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва',@regcard_number='D001'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Русскин Алексей Сергеевич',@birthday='07.06.1997',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='Русскин Алексей Сергеевич',@player_birthday='07.06.1997'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Щелкунов Даниил Александрович',@birthday='20.04.1998',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='Щелкунов Даниил Александрович',@player_birthday='20.04.1998'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Фолифоров Даниил Сергеевич',@birthday='21.09.1998',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='Фолифоров Даниил Сергеевич',@player_birthday='21.09.1998'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Хомцов Владислав Владимирович',@birthday='05.09.1997',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='Хомцов Владислав Владимирович',@player_birthday='05.09.1997'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Гончаров Михаил Юрьевич',@birthday='12.02.1998',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='Гончаров Михаил Юрьевич',@player_birthday='12.02.1998'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Чувиляева Ирина Павловна',@birthday='23.05.1999',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='Чувиляева Ирина Павловна',@player_birthday='23.05.1999'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Буракова Анастасия Владимировна',@birthday='11.12.1997',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='Буракова Анастасия Владимировна',@player_birthday='11.12.1997'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Никитенко Дарья Александровна',@birthday='19.08.1997',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='Никитенко Дарья Александровна',@player_birthday='19.08.1997'
exec addPlayer @rate_id='',@team_name='Игугундер',@name='Мишин Денис Андреевич',@birthday='05.07.1997',@is_captain='True',@is_legioner='False'
exec addPlayer2Season @player_name='Мишин Денис Андреевич',@player_birthday='05.07.1997'
exec addPlayer2GameRound @player_name='Русскин Алексей Сергеевич',@player_birthday='07.06.1997',@player_team_name='Игугундер',@tour_number='2',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Щелкунов Даниил Александрович',@player_birthday='20.04.1998',@player_team_name='Игугундер',@tour_number='2',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Гончаров Михаил Юрьевич',@player_birthday='12.02.1998',@player_team_name='Игугундер',@tour_number='2',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Чувиляева Ирина Павловна',@player_birthday='23.05.1999',@player_team_name='Игугундер',@tour_number='2',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Буракова Анастасия Владимировна',@player_birthday='11.12.1997',@player_team_name='Игугундер',@tour_number='2',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Мишин Денис Андреевич',@player_birthday='05.07.1997',@player_team_name='Игугундер',@tour_number='2',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Фолифоров Даниил Сергеевич',@player_birthday='21.09.1998',@player_team_name='Игугундер',@tour_number='1',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Хомцов Владислав Владимирович',@player_birthday='05.09.1997',@player_team_name='Игугундер',@tour_number='1',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Гончаров Михаил Юрьевич',@player_birthday='12.02.1998',@player_team_name='Игугундер',@tour_number='1',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Чувиляева Ирина Павловна',@player_birthday='23.05.1999',@player_team_name='Игугундер',@tour_number='1',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Буракова Анастасия Владимировна',@player_birthday='11.12.1997',@player_team_name='Игугундер',@tour_number='1',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Никитенко Дарья Александровна',@player_birthday='19.08.1997',@player_team_name='Игугундер',@tour_number='1',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'
exec addPlayer2GameRound @player_name='Мишин Денис Андреевич',@player_birthday='05.07.1997',@player_team_name='Игугундер',@tour_number='1',@tournament_name='14 Чемпионат МО по ЧГК.',@tournament_city='Москва'

--exec DeleteTeam @teamname='Игугундер'

SELECT *
FROM Team

SELECT *
FROM TeamTournament
WHERE regcard_number = 'D001'

SELECT *
FROM Player
WHERE Player.name = 'Русскин Алексей Сергеевич'

DROP PROCEDURE DeleteTeam;

