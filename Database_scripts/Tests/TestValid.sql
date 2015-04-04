
CREATE PROCEDURE CheckAnswers
	@authors_answer NVARCHAR(MAX),
	@question_num	INT
AS
	UPDATE Answer
	SET is_valid = 1
	WHERE question_num = @question_num AND answer_text = @authors_answer
GO

exec CheckAnswers @authors_answer='Берлин', @question_num=21
exec CheckAnswers @authors_answer='Самсон', @question_num=16
exec CheckAnswers @authors_answer='Смешарики', @question_num=19

SELECT Team.name, COUNT(Answer.answer_text)
FROM Team, Answer
WHERE Team.id = Answer.team_id AND Answer.is_valid = 1
GROUP BY Team.name
ORDER BY COUNT(Answer.answer_text) DESC

DROP PROCEDURE CheckAnswers;
