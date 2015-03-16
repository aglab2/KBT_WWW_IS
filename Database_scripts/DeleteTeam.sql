CREATE PROCEDURE DeleteTeam
	@teamname NVARCHAR(max)
AS
	DELETE FROM Team
	WHERE Team.name = @teamname
GO


exec addTournament @city='������',@name='14 ��������� �� �� ���.',@password='fi9QT3HR6'
exec addTeam @name='���������',@phone='',@email='lolopoolik@yandex.ru',@city='������������'
exec addTeam2Tournament @team_name='���������',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������',@regcard_number='D001'
exec addPlayer @rate_id='',@team_name='���������',@name='������� ������� ���������',@birthday='07.06.1997',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='������� ������� ���������',@player_birthday='07.06.1997'
exec addPlayer @rate_id='',@team_name='���������',@name='�������� ������ �������������',@birthday='20.04.1998',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='�������� ������ �������������',@player_birthday='20.04.1998'
exec addPlayer @rate_id='',@team_name='���������',@name='��������� ������ ���������',@birthday='21.09.1998',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='��������� ������ ���������',@player_birthday='21.09.1998'
exec addPlayer @rate_id='',@team_name='���������',@name='������ ��������� ������������',@birthday='05.09.1997',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='������ ��������� ������������',@player_birthday='05.09.1997'
exec addPlayer @rate_id='',@team_name='���������',@name='�������� ������ �������',@birthday='12.02.1998',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='�������� ������ �������',@player_birthday='12.02.1998'
exec addPlayer @rate_id='',@team_name='���������',@name='��������� ����� ��������',@birthday='23.05.1999',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='��������� ����� ��������',@player_birthday='23.05.1999'
exec addPlayer @rate_id='',@team_name='���������',@name='�������� ��������� ������������',@birthday='11.12.1997',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='�������� ��������� ������������',@player_birthday='11.12.1997'
exec addPlayer @rate_id='',@team_name='���������',@name='��������� ����� �������������',@birthday='19.08.1997',@is_captain='False',@is_legioner='False'
exec addPlayer2Season @player_name='��������� ����� �������������',@player_birthday='19.08.1997'
exec addPlayer @rate_id='',@team_name='���������',@name='����� ����� ���������',@birthday='05.07.1997',@is_captain='True',@is_legioner='False'
exec addPlayer2Season @player_name='����� ����� ���������',@player_birthday='05.07.1997'
exec addPlayer2GameRound @player_name='������� ������� ���������',@player_birthday='07.06.1997',@player_team_name='���������',@tour_number='2',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='�������� ������ �������������',@player_birthday='20.04.1998',@player_team_name='���������',@tour_number='2',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='�������� ������ �������',@player_birthday='12.02.1998',@player_team_name='���������',@tour_number='2',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='��������� ����� ��������',@player_birthday='23.05.1999',@player_team_name='���������',@tour_number='2',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='�������� ��������� ������������',@player_birthday='11.12.1997',@player_team_name='���������',@tour_number='2',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='����� ����� ���������',@player_birthday='05.07.1997',@player_team_name='���������',@tour_number='2',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='��������� ������ ���������',@player_birthday='21.09.1998',@player_team_name='���������',@tour_number='1',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='������ ��������� ������������',@player_birthday='05.09.1997',@player_team_name='���������',@tour_number='1',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='�������� ������ �������',@player_birthday='12.02.1998',@player_team_name='���������',@tour_number='1',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='��������� ����� ��������',@player_birthday='23.05.1999',@player_team_name='���������',@tour_number='1',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='�������� ��������� ������������',@player_birthday='11.12.1997',@player_team_name='���������',@tour_number='1',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='��������� ����� �������������',@player_birthday='19.08.1997',@player_team_name='���������',@tour_number='1',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'
exec addPlayer2GameRound @player_name='����� ����� ���������',@player_birthday='05.07.1997',@player_team_name='���������',@tour_number='1',@tournament_name='14 ��������� �� �� ���.',@tournament_city='������'

--exec DeleteTeam @teamname='���������'

SELECT *
FROM Team

SELECT *
FROM TeamTournament
WHERE regcard_number = 'D001'

SELECT *
FROM Player
WHERE Player.name = '������� ������� ���������'

DROP PROCEDURE DeleteTeam;

