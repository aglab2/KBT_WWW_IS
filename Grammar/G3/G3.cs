using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;

[System.Serializable]
public class Attribute
{
    class Team
    {
        public string global_id;
        public string name;
        public string email;
        public string city;
        public Collection<string> agecat;

        public Team(string global_id, string name, string email, string city, Collection<string> agecat)
        {
            this.global_id = global_id;
            this.name = name;
            this.email = email;
            this.city = city;
            this.agecat = agecat;
        }
    }

    class Player
    {
        public string team_name;
        public string name;
        public string bday;
        public string is_captain;

        public Player(string team_id, string name, string bday, string is_captain)
        {
            this.team_name = team_id;
            this.name = name;
            this.bday = bday;
            this.is_captain = is_captain;
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
        public int state;
        public int teamnum;
        public string answer;
        public string team;

        public Answer(int correct, int teamnum, string answer)
        {
            this.state = correct;
            this.teamnum = teamnum;
            this.answer = answer;
            team = null;
        }
    }

    const string city = "ÃÓÒÍ‚‡";
    const string name = "ÿ–Â ";
    const string password = "";

    public Collection<object> Start(Collection<object> w1, Collection<object> A)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<Team> teams = (Collection<Team>)A[1];
        Collection<Player> caps = (Collection<Player>)A[2];
        Collection<Question> questions = (Collection<Question>)A[3];

        Collection<Tuple<string, string>> arg = new Collection<Tuple<string, string>>();
        Tuple<string, Collection<Tuple<string, string>>> comm = new Tuple<string, Collection<Tuple<string, string>>>("addTournament", arg);
        arg.Add(Tuple.Create("@city", city));
        arg.Add(Tuple.Create("@name", name));
        arg.Add(Tuple.Create("@password", password));
        ret.Add(comm);

        arg = new Collection<Tuple<string, string>>();
        comm = new Tuple<string, Collection<Tuple<string, string>>>("addGameRound", arg);
        arg.Add(Tuple.Create("@gamenumber", "1"));
        arg.Add(Tuple.Create("@city", city));
        arg.Add(Tuple.Create("@tournament_name", name));
        ret.Add(comm);

        foreach (Team i in teams)
        {
            arg = new Collection<Tuple<string, string>>();
            comm = new Tuple<string, Collection<Tuple<string, string>>>("addTeam", arg);
            arg.Add(Tuple.Create("@name", i.name.Trim()));
            if (i.email != "") arg.Add(Tuple.Create("@email", i.email.Trim()));
            arg.Add(Tuple.Create("@city", i.city.Trim())); //TODO
            ret.Add(comm);

            arg = new Collection<Tuple<string, string>>();
            comm = new Tuple<string, Collection<Tuple<string, string>>>("addTeam2Tournament", arg);
            int parsed;
            if (int.TryParse(i.global_id, out parsed))
                arg.Add(Tuple.Create("@regcard_number", w1[0] + i.global_id.Trim()));
            else
                arg.Add(Tuple.Create("@regcard_number", i.global_id.Trim()));
            arg.Add(Tuple.Create("@tournament_name", name.Trim()));
            arg.Add(Tuple.Create("@tournament_city", city.Trim()));
            arg.Add(Tuple.Create("@team_name", i.name.Trim()));
            ret.Add(comm);

            foreach (string j in i.agecat)
            {
                arg = new Collection<Tuple<string, string>>();
                comm = new Tuple<string, Collection<Tuple<string, string>>>("addAgeCategory2TeamTournament", arg);
                arg.Add(Tuple.Create("@tournament_name", name.Trim()));
                arg.Add(Tuple.Create("@tournament_city", city.Trim()));
                arg.Add(Tuple.Create("@team_name", i.name.Trim()));
                arg.Add(Tuple.Create("@age_category", j));

                ret.Add(comm);
            }
        }

        foreach (Player i in caps)
        {
            arg = new Collection<Tuple<string, string>>();
            comm = new Tuple<string, Collection<Tuple<string, string>>>("addPlayer", arg);
            arg.Add(Tuple.Create("@team_name", i.team_name.Trim()));
            arg.Add(Tuple.Create("@name", i.name.Trim()));
            if (i.bday != "") arg.Add(Tuple.Create("@birthday", i.bday));
            arg.Add(Tuple.Create("@is_captain", i.is_captain));
            ret.Add(comm);


            arg = new Collection<Tuple<string, string>>();
            comm = new Tuple<string, Collection<Tuple<string, string>>>("addPlayer2Season", arg);
            arg.Add(Tuple.Create("@player_name", i.name.Trim()));
            if (i.bday != "") arg.Add(Tuple.Create("@player_birthday", i.bday));
            ret.Add(comm);
        }

        foreach (Question q in questions)
        {
            foreach (Answer a in q.ans)
            {
                if (a.team == null) throw new Exception("Num " + a.teamnum + " is not correct!");
                arg = new Collection<Tuple<string, string>>();
                comm = new Tuple<string, Collection<Tuple<string, string>>>("addAnswer", arg);
                arg.Add(Tuple.Create("@team_name", a.team.Trim()));
                arg.Add(Tuple.Create("@question_num", q.num.ToString()));
                arg.Add(Tuple.Create("@answer_text", a.answer.Trim()));
                arg.Add(Tuple.Create("@is_valid", a.state.ToString()));
                arg.Add(Tuple.Create("@tournament_name", name));
                arg.Add(Tuple.Create("@city", city));
                arg.Add(Tuple.Create("@gamenumber", "1"));

                ret.Add(comm);
            }
        }
        
        //ret.Add(questions);
        return ret;
    }

    /*
     * 1 - Team Collection
     * 2 - Captain Collection
    */
    public Collection<object> A1(Collection<object> n1, Collection<object> palka1, Collection<object> n2, Collection<object> palka2, Collection<object> B, Collection<object> palka3,
        Collection<object> W1, Collection<object> palka4, Collection<object> W2, Collection<object> palka5, Collection<object> W3, Collection<object> palka6,
        Collection<object> W4, Collection<object> nl, Collection<object> A)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<Team> teams = (Collection<Team>)A[1];
        Collection<Player> caps = (Collection<Player>)A[2];
        Collection<Question> questions = (Collection<Question>)A[3];

        try
        {
            int parsed = -1;
            int.TryParse((string)n1[1], out parsed);

            foreach (Question q in questions)
                foreach (Answer a in q.ans)
                    if (a.teamnum == parsed)
                        a.team = (string)W1[1];

            teams.Add(new Team((string)n2[1], (string)W1[1], (string)W4[1], (string)W3[1], (Collection<string>)B[1]));
            caps.Add(new Player((string)W1[1], (string)W2[1], "", "true"));
            ret.Add(teams);
            ret.Add(caps);
            ret.Add(questions);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    /*
     * 1 - Team Collection
    */
    public Collection<object> A2(Collection<object> n1, Collection<object> palka1, Collection<object> n2, Collection<object> palka2, Collection<object> B, Collection<object> palka3,
        Collection<object> W1, Collection<object> palka4, Collection<object> W2, Collection<object> palka5, Collection<object> W3,
        Collection<object> nl, Collection<object> A)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<Team> teams = (Collection<Team>)A[1];
        Collection<Player> caps = (Collection<Player>)A[2];
        Collection<Question> questions = (Collection<Question>)A[3];
    
        try
        {
            int parsed = 0;
            int.TryParse((string)n1[1], out parsed);

            foreach (Question q in questions)
                foreach (Answer a in q.ans)
                    if (a.team == null && a.teamnum == parsed)
                        a.team = (string)W1[1];

            teams.Add(new Team((string)n2[1], (string)W1[1], "", (string)W3[1], (Collection<string>)B[1]));
            caps.Add(new Player((string)W1[1], (string)W2[1], "", "true"));
            ret.Add(teams);
            ret.Add(caps);
            ret.Add(questions);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    /*
     * 1 - Team Collection
    */
    public Collection<object> A3(Collection<object> n1, Collection<object> palka1, Collection<object> n2, Collection<object> palka2, Collection<object> B, Collection<object> palka3,
        Collection<object> W1, Collection<object> palka4, Collection<object> W2, Collection<object> nl, Collection<object> A)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<Team> teams = (Collection<Team>)A[1];
        Collection<Player> caps = (Collection<Player>)A[2];
        Collection<Question> questions = (Collection<Question>)A[3];

        try
        {
            int parsed = 0;
            int.TryParse((string)n1[1], out parsed);

            foreach (Question q in questions)
                foreach (Answer a in q.ans)
                    if (a.team == null && a.teamnum == parsed)
                        a.team = (string)W1[1];

            teams.Add(new Team((string)n2[1], (string)W1[1], "", "", (Collection<string>)B[1]));
            caps.Add(new Player((string)W1[1], (string)W2[1], "", "true"));
            ret.Add(teams);
            ret.Add(caps);
            ret.Add(questions);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    /*
     * 1 - Team Collection
    */
    public Collection<object> A4(Collection<object> n1, Collection<object> palka1, Collection<object> n2, Collection<object> palka2, Collection<object> B, Collection<object> palka3,
        Collection<object> W1, Collection<object> nl, Collection<object> A)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<Team> teams = (Collection<Team>)A[1];
        Collection<Player> caps = (Collection<Player>)A[2];
        Collection<Question> questions = (Collection<Question>)A[3];

        try
        {
            int parsed = 0;
            int.TryParse((string)n1[1], out parsed);

            foreach (Question q in questions)
                foreach (Answer a in q.ans)
                    if (a.team == null && a.teamnum == parsed)
                        a.team = (string)W1[1];

            teams.Add(new Team((string)n2[1], (string)W1[1], "", "", (Collection<string>)B[1]));
            ret.Add(teams);
            ret.Add(caps);
            ret.Add(questions);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> B1(Collection<object> w1, Collection<object> cp, Collection<object> B)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<string> col = (Collection<string>)B[1];
        col.Add((string)w1[0]);

        ret.Add(col);
        return ret;
    }

    public Collection<object> B3(Collection<object> w1)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<string> col = new Collection<string>();
        col.Add((string)w1[0]);

        ret.Add(col);
        return ret;
    }

    public Collection<object> BB3(Collection<object> w1, Collection<object> p)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<string> col = new Collection<string>();
        col.Add((string)w1[0]);

        ret.Add(col);
        return ret;
    }



    public Collection<object> C1(Collection<object> S)
    {
        return S;
    }

    public Collection<object> C2(Collection<object> p, Collection<object> S)
    {
        return S;
    }

    public Collection<object> NextE(Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(new Collection<Team>());
        ret.Add(new Collection<Player>());
        ret.Add(E[1]);
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
                Answer a = new Answer(1, i, (string)W[1]);
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

    public Collection<object> F3p(Collection<object> q, Collection<object> n, Collection<object> I, Collection<object> nl, Collection<object> F)
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
                Answer a = new Answer(1, i, "");
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

    public Collection<object> F4(Collection<object> q, Collection<object> n, Collection<object> I, Collection<object> p, Collection<object> W, Collection<object> nl, Collection<object> F)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<int> teams = (Collection<int>)I[1];
        Collection<Answer> answers = (Collection<Answer>)F[1];

        try
        {
            teams.Add((int)n[0]);
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

    public Collection<object> F5(Collection<object> p, Collection<object> nl, Collection<object> F)
    {
        return F;
    }

    public Collection<object> F0()
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

    public Collection<object> w2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add("");
        return ret;
    }


    public Collection<object> Pp1(Collection<object> p1, Collection<object> s, Collection<object> p2)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add((string)s[0]);
        return ret;
    }

    public Collection<object> Pp3(Collection<object> p1, Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add((string)s[0]);
        return ret;
    }

    public Collection<object> Pp2(Collection<object> s, Collection<object> p2)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add((string)s[0]);
        return ret;
    }

    public Collection<object> Pp4(Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add((string)s[0]);
        return ret;
    }

}