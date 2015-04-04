using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;

[System.Serializable]
public class Attribute
{
    class Team
    {
        public string team_regcard;
        public int internal_number;

        public Team(string team_regcard, int internal_number)
        {
            this.team_regcard = team_regcard;
            this.internal_number = internal_number;
        }
    }

    class Question
    {
        public int num;
        public Collection<Answer> ans;

        public Question(int num, Collection<Answer> ans)
        {
            this.num = num;
            this.ans = ans;
        }
    }

    class Answer
    {
        public int numq;
        public int state;
        public int teamnum;
        public string answer;
        public string team_regcard; // send to server only not null value!

        public Answer(int correct, int teamnum, string answer)
        {
            this.state = correct;
            this.teamnum = teamnum;
            this.answer = answer;
            this.team_regcard = null;
            this.numq = 0;
        }
    }

    class Player { };
    
    public Collection<object> Start(Collection<object> w, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
      
        Collection<Tuple<string, string>> arg;
        Tuple<string, Collection<Tuple<string, string>>> comm;

        Collection<Question> Questions = (Collection<Question>)S[3];
        foreach (Question q in Questions)
        {
            foreach (Answer i in q.ans)
            {
                if (i.team_regcard == null) continue;

                arg = new Collection<Tuple<string, string>>();
                comm = new Tuple<string, Collection<Tuple<string, string>>>("addAnswerByGlobalID", arg);

                arg.Add(Tuple.Create("@regcard_number", i.team_regcard));
                arg.Add(Tuple.Create("@question_num", i.numq.ToString()));
                arg.Add(Tuple.Create("@answer_text", i.answer));
                arg.Add(Tuple.Create("@is_valid", i.state.ToString()));
                arg.Add(Tuple.Create("@tournament_name", "14 Чемпионат МО по ЧГК."));
                arg.Add(Tuple.Create("@tournament_city", "Москва"));
                arg.Add(Tuple.Create("@gamenumber", "1"));
                ret.Add(comm);
            }
        }

        return ret;
    }

    public Collection<object> S1(Collection<object> w, Collection<object> p, Collection<object> n, Collection<object> nl, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        Collection<Team> teams = (Collection<Team>)S[1];
        Collection<Player> Players = (Collection<Player>)S[2]; //is null
        Collection<Question> questions = (Collection<Question>)S[3];

        try
        {
            int parsed = -1;
            int.TryParse((string)n[0], out parsed);

            foreach (Question q in questions)
                foreach (Answer a in q.ans)
                    if (a.teamnum == parsed)
                    {
                        a.numq = q.num;
                        a.team_regcard = (string)w[0];
                    }

            teams.Add(new Team((string)w[0], parsed));
            ret.Add(teams);
            ret.Add(Players); //is null
            ret.Add(questions);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }


        return ret;
    }

    public Collection<object> S2(Collection<object> n, Collection<object> p, Collection<object> w, Collection<object> nl, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        Collection<Team> teams = (Collection<Team>)S[1];
        Collection<Player> Players = (Collection<Player>)S[2]; //is null
        Collection<Question> questions = (Collection<Question>)S[3];

        try
        {
            int parsed = -1;
            int.TryParse((string)n[0], out parsed);

            foreach (Question q in questions)
                foreach (Answer a in q.ans)
                    if (a.teamnum == parsed)
                    {
                        a.numq = q.num;
                        a.team_regcard = (string)w[0];
                    }

            teams.Add(new Team((string)w[0], parsed));
            ret.Add(teams);
            ret.Add(Players); //is null
            ret.Add(questions);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }


        return ret;
    }

    public Collection<object> S3(Collection<object> w, Collection<object> nl, Collection<object> S)
    {
        return S;
    }

    public Collection<object> NextE(Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(new Collection<Team>());
        ret.Add(null);//ret.Add(new Collection<Player>());
        ret.Add(E[1]); //questions
        return ret;
    }

    public Collection<object> E1(Collection<object> v, Collection<object> n, Collection<object> nl, Collection<object> F, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<Question> questions = (Collection<Question>)E[1];
        Collection<Answer> ans = (Collection<Answer>)F[1];

        try
        {
            int parsed = 0;
            int.TryParse((string)n[0], out parsed);
            Question q = new Question(parsed, ans);
            questions.Add(q);
            ret.Add(questions);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> E2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(new Collection<Question>());
        return ret;
    }

    public Collection<object> F1(Collection<object> n, Collection<object> I, Collection<object> p, Collection<object> W, Collection<object> nl, Collection<object> F)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<int> teams = (Collection<int>)I[1];
        Collection<Answer> answers = (Collection<Answer>)F[1];

        try
        {
            int parsed = 0;
            int.TryParse((string)n[0], out parsed);
            teams.Add(parsed);
            foreach (int i in teams)
            {
                Answer a = new Answer(0, i, (string)W[1]);
                answers.Add(a);
            }
            ret.Add(answers);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> F2(Collection<object> n, Collection<object> I, Collection<object> nl, Collection<object> F)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<int> teams = (Collection<int>)I[1];
        Collection<Answer> answers = (Collection<Answer>)F[1];

        try
        {
            int parsed = 0;
            int.TryParse((string)n[0], out parsed);
            teams.Add(parsed);
            foreach (int i in teams)
            {
                Answer a = new Answer(0, i, "");
                answers.Add(a);
            }
            ret.Add(answers);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> F3(Collection<object> q, Collection<object> n, Collection<object> I, Collection<object> p, Collection<object> W, Collection<object> nl, Collection<object> F)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<int> teams = (Collection<int>)I[1];
        Collection<Answer> answers = (Collection<Answer>)F[1];

        try
        {
            int parsed = 0;
            int.TryParse((string)n[0], out parsed);
            teams.Add(parsed);
            foreach (int i in teams)
            {
                Answer a = new Answer(2, i, (string)W[1]);
                answers.Add(a);
            }
            ret.Add(answers);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }


    public Collection<object> F4()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(new Collection<Answer>());
        return ret;
    }

    public Collection<object> I1(Collection<object> c, Collection<object> n, Collection<object> I)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        int parsed = 0;

        try
        {
            Collection<int> teams = (Collection<int>)I[1];
            int.TryParse((string)n[0], out parsed);
            teams.Add(parsed);
            ret.Add(teams);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> I2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(new Collection<int>());
        return ret;
    }


    public Collection<object> w(Collection<object> W, Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add((string)W[1] + (string)s[0]);
        return ret;
    }

    public Collection<object> w1(Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add((string)s[0]);
        return ret;
    }
}
