-- ������ ������� �� �������, � ��������� ������ �������� ���������� � �������, � ������� ��� ���� ����
IF OBJECT_ID ('Answers_of_Team', 'V') IS NOT NULL
DROP VIEW Answers_of_Team;
GO
CREATE VIEW Answers_of_Team AS
	SELECT Team.name '������� �� �������', Tournament.name as '�������� �������', Tournament.season_id as '�����', 
			adr_tournament.name as '����� ����������', Answer.question_num as '����� �������', Answer.answer_text as '�����', Answer.is_valid as '������?'
		FROM Team, Answer, "Address" as adr_team, GameRound, Tournament, "Address" as adr_tournament
 		WHERE Answer.team_id = Team.id AND Team.address_id = adr_team.id AND Answer.gameround_id = GameRound.id 
		AND GameRound.tournament_id = Tournament.id AND adr_team.name = '������' AND Tournament.address_id = adr_tournament.id
GO

-- ������ ������ �� �������, ������� �� ����������� 18 ���
IF OBJECT_ID ('Players_of_Team', 'V') IS NOT NULL
DROP VIEW Players_of_Team;
GO
CREATE VIEW Players_of_Team AS
	SELECT Team.name '������� �� �������', Tournament.name as '�������� �������',
				Tournament.season_id as '�����',  adr_tournament.name as '����� ����������',
				Player.name as '���', Player.birthday, DATEDIFF(YEAR,  Player.birthday, Season.begin_date) as '������� �� ������ �������'
		FROM Player, Team, "Address" as adr_team, TeamTournament, Tournament, "Address" as adr_tournament, Season
 		WHERE Player.team_id = Team.id AND Team.address_id = adr_team.id AND adr_team.name = '������������'
		AND Team.id = TeamTournament.team_id AND TeamTournament.tournament_id = Tournament.id AND adr_tournament.id = Tournament.address_id
		AND Season.id = Tournament.season_id AND DATEDIFF(YEAR, Player.birthday, Season.begin_date) < 18
GO


SELECT *
FROM Players_of_Team
ORDER BY  Players_of_Team.[������� �� �������]
