using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;

[System.Serializable]
public class Attribute
{
    class Answer
    {
        public int numq;
        public int state;
        public string answer;
        
        public Answer(int numq, int correct, string answer)
        {
            this.numq = numq;
            this.state = correct;
            this.answer = answer;
        }
    }

    public Collection<object> Start(Collection<object> w, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        Collection<Tuple<string, string>> arg;
        Tuple<string, Collection<Tuple<string, string>>> comm;

        Collection<Answer> Answers = (Collection<Answer>)S[1];
        foreach (Answer i in Answers)
        {
            arg = new Collection<Tuple<string, string>>();
            comm = new Tuple<string, Collection<Tuple<string, string>>>("addAnswerByGlobalID", arg);

            arg.Add(Tuple.Create("@regcard_number", (string)w[0]));
            arg.Add(Tuple.Create("@question_num", i.numq.ToString()));
            arg.Add(Tuple.Create("@answer_text", i.answer));
            arg.Add(Tuple.Create("@is_valid", i.state.ToString()));
            arg.Add(Tuple.Create("@tournament_name", "14 Чемпионат МО по ЧГК."));
            arg.Add(Tuple.Create("@tournament_city", "Москва"));
            arg.Add(Tuple.Create("@gamenumber", "1"));
            ret.Add(comm);
        }

        return ret;
    }

    public Collection<object> S1(Collection<object> n, Collection<object> d, Collection<object> p, Collection<object> W, Collection<object> nl, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        int parsed = -1;
        int.TryParse((string)n[0], out parsed);

        
        Collection<Answer> Answers = (Collection<Answer>)S[1];
        Answer a = new Answer(parsed, 0, (string)W[1]);

        Answers.Add(a);
        ret.Add(Answers);
        return ret;
    }

    public Collection<object> S2(Collection<object> n, Collection<object> q, Collection<object> d, Collection<object> p, Collection<object> W, Collection<object> nl, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        int parsed = -1;
        int.TryParse((string)n[0], out parsed);

        Collection<Answer> Answers = (Collection<Answer>)S[1];
        Answer a = new Answer(parsed, 2, (string)W[1]);

        Answers.Add(a);
        ret.Add(Answers);
        return ret;
    }

    public Collection<object> S0()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(new Collection<Answer>());
        return ret;
    }


    public Collection<object> w(Collection<object> W, Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            ret.Add((string)W[1] + (string)s[0]);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> w2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add("");
        return ret;
    }

    public Collection<object> w1(Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        try
        {
            ret.Add((string)s[0]);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

}
