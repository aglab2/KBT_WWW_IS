using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;

[System.Serializable]
public class Attribute
{
    class Team
    {
        public string age_category;
        public string global_id;
        public string name;
        public string email;
        public string city;

        public Team()
        {
            this.global_id = null;
            this.name = null;
            this.email = null;
            this.city = null;
            this.age_category = null;
        }
    }

    class Player
    {
        public int num;
        public string team_global_id;
        public string name;
        public string bday;
        public string is_captain;
        public string rate_id;

        public Player(int num, string name, string bday, string is_captain, string rate_id)
        {
            this.num = num;
            this.team_global_id = null;
            this.name = name;
            this.bday = bday;
            this.is_captain = is_captain;
            this.rate_id = rate_id;
        }
    }

    class Tour
    {
        public int num;
        public Collection<int> playernums;
        public Collection<Player> players;

        public Tour(int num, Collection<int> playernums)
        {
            this.num = num;
            this.playernums = playernums;
        }
    }

    public Collection<object> S1(Collection<object> w0, Collection<object> w1, Collection<object> k1, Collection<object> w2, Collection<object> k2,
         Collection<object> w3, Collection<object> nl, Collection<object> D)
    {
        //Console.WriteLine("Hello!");
        return null;
    }

    public Collection<object> D(Collection<object> W1, Collection<object> c1, Collection<object> W2, Collection<object> nl, Collection<object> D)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Team TheTeam;
        if (D[1] == null) 
            TheTeam = new Team(); 
            else TheTeam = (Team)D[1];

        string doubledeclare = "";

        if ((string)W1[1] == "Название команды")
        {
            if (TheTeam.name == null) TheTeam.name = (string)W2[1];
            else doubledeclare = (string)W1[1];
        }
        else
            if ((string)W1[1] == "Возрастная категория")
            {
                if (TheTeam.age_category == null) TheTeam.age_category = (string)W2[1];
                else doubledeclare = (string)W1[1];
            }
            else
                if ((string)W1[1] == "Город")
                {
                    if (TheTeam.city == null) TheTeam.city = (string)W2[1];
                    else doubledeclare = (string)W1[1];
                }
                else
                    if ((string)W1[1] == "ID в рейтинге")
                    {
                        if (TheTeam.global_id == null) TheTeam.global_id = (string)W2[1];
                        else doubledeclare = (string)W1[1];
                    }
                    else
                        if ((string)W1[1] == "Email/тел.")
                        {
                            if (TheTeam.email == null) TheTeam.email = (string)W2[1];
                            else doubledeclare = (string)W1[1];
                        }
                        else
                            ret[0] = "WRONG DECLARE!";

        ret.Add(TheTeam);

        return ret;

    }

    public Collection<object> D1(Collection<object> W1, Collection<object> c1, Collection<object> p2, Collection<object> nl, Collection<object> D)
    {
        return null;
        //what the hell here?
    }

    public Collection<object> D2(Collection<object> W1, Collection<object> c1, Collection<object> nl, Collection<object> D)
    {
        return D;
    }

    public Collection<object> Email1(Collection<object> w1, Collection<object> s1, Collection<object> w2,
    Collection<object> d1, Collection<object> c1, Collection<object> EmailWord, 
        Collection<object> dd3, Collection<object> Phone, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            //Email/тел.
            if ((string)w1[0] == "Email" && (string)w2[0] == "тел")
            {
                ret.Add(EmailWord[1]);
                ret.Add(Phone[1]);
            }
            else throw new Exception("Wrong e-mail/phone description!!!");
        }
        catch (Exception e)
        {
            ret[0] = e;
        }


        return ret;
    }

    public Collection<object> Email2(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1,
        Collection<object> c1, Collection<object> EmailWord, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            //Email/тел.
            if ((string)w1[0] == "Email" && (string)w2[0] == "тел")
            {
                ret.Add(EmailWord[1]);
                ret.Add("");
            }
            else throw new Exception("Wrong e-mail/phone description!!!");
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> Email3(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1,
    Collection<object> c1, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            //Email/тел.
            if ((string)w1[0] == "Email" && (string)w2[0] == "тел")
            {
                ret.Add("");
                ret.Add("");
            }
            else throw new Exception("Wrong e-mail/phone description!!!");
        }
        catch (Exception e)
        {
            ret[0] = e;
        }


        return ret;
    }

    public Collection<object> Email5(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1,
    Collection<object> c1, Collection<object> Phone, Collection<object> w3, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            //Email/тел.
            if ((string)w1[0] == "Email" && (string)w2[0] == "тел")
            {
                ret.Add("");
                ret.Add(Phone[1]);
            }
            else throw new Exception("Wrong e-mail/phone description!!!");
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> E(Collection<object> W1, Collection<object> c1, Collection<object> W2, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Team TheTeam;
        if (E[1] == null) TheTeam = new Team(); else TheTeam = (Team)E[1];
        string doubledeclare = "";

        if ((string)W1[1] == "Название команды")
        {
            if (TheTeam.name == null) TheTeam.name = (string)W2[1];
            else doubledeclare = (string)W1[1];
        }
        else
            if ((string)W1[1] == "Возрастная категория")
            {
                if (TheTeam.age_category == null) TheTeam.age_category = (string)W2[1];
                else doubledeclare = (string)W1[1];
            }
            else
                if ((string)W1[1] == "Город")
                {
                    if (TheTeam.city == null) TheTeam.city = (string)W2[1];
                    else doubledeclare = (string)W1[1];
                }
                else
                    if ((string)W1[1] == "ID в рейтинге")
                    {
                        if (TheTeam.global_id == null) TheTeam.global_id = (string)W2[1];
                        else doubledeclare = (string)W1[1];
                    }
                    else
                        if ((string)W1[1] == "Email/тел.")
                        {
                            if (TheTeam.email == null) TheTeam.email = (string)W2[1];
                                else doubledeclare = (string)W1[1];
                        }
                        else
                            ret[0] = "WRONG DECLARE!";

        ret.Add(TheTeam);
        return ret;
    }

    public Collection<object> E1(Collection<object> W1, Collection<object> c1, Collection<object> p2, Collection<object> nl, Collection<object> E)
    {
        // what the hell here?
        return E;
    }

    public Collection<object> E2(Collection<object> W1, Collection<object> c1, Collection<object> nl, Collection<object> E)
    {
        return E;
    }

    public Collection<object> NextP(Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(P);
        return ret;
    }

    public Collection<object> P1(Collection<object> s1, Collection<object> n1, Collection<object> Name, 
        Collection<object> c1, Collection<object> Date, Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            
            Player ThePlayer = new Player(parsed, (string)Name[1], (string)Date[1], false.ToString(), "");

            Collection<Player> Players = (Collection<Player>)P[1];
            Players.Add(ThePlayer);

            ret.Add(Players);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> P6(Collection<object> sym, Collection<object> s1, Collection<object> n1, Collection<object> Name,
        Collection<object> c1, Collection<object> p4, Collection<object> Date, Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {  
            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            bool is_capitan = ((string)sym[0] == "+" || (string)sym[0] == "К" || (string)sym[0] == "K") ? true : false;
            Player ThePlayer = new Player(parsed, (string)Name[1], (string)Date[1], is_capitan.ToString(), null);

            Collection<Player> Players = (Collection<Player>)P[1];

            if (is_capitan)
                foreach (var Vasya in Players)
                    if (Vasya.is_captain == is_capitan.ToString()) throw new Exception("More than one capitan!");

            Players.Add(ThePlayer);

            ret.Add(Players);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> P4(Collection<object> s1, Collection<object> n1, Collection<object> Name,
        Collection<object> c1, Collection<object> s2, Collection<object> Date, Collection<object> c2, 
        Collection<object> s3, Collection<object> nE, Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            Player ThePlayer = new Player(parsed, (string)Name[1], (string)Date[1], false.ToString(), (string)nE[1]);

            Collection<Player> Players = (Collection<Player>)P[1];
            Players.Add(ThePlayer);

            ret.Add(Players);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> P7(Collection<object> sym, Collection<object> s1, Collection<object> n1, Collection<object> Name,
        Collection<object> c1, Collection<object> p8, Collection<object> Date, Collection<object> c2, Collection<object> p4, Collection<object> n5,
        Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            bool is_capitan = ((string)sym[0] == "+" || (string)sym[0] == "К" || (string)sym[0] == "K") ? true : false;

            Player ThePlayer = new Player(parsed, (string)Name[1], (string)Date[1], is_capitan.ToString(), (string)n5[0]);

            Collection<Player> Players = (Collection<Player>)P[1];
            
            // check bug
            if (is_capitan)
            foreach (var Vasya in Players)
                if (Vasya.is_captain == is_capitan.ToString()) throw new System.Exception("More than one capitan!");

            Players.Add(ThePlayer);

            ret.Add(Players);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> P3(Collection<object> s1, Collection<object> n1, Collection<object> nl, Collection<object> P)
    {
        return P;
    }


    public Collection<object> Q1(Collection<object> s, Collection<object> n1, Collection<object> nl, Collection<object> Q)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> NextH(Collection<object> H)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(H);
        return ret;
    }

    public Collection<object> H1(Collection<object> n1, Collection<object> p, Collection<object> I, Collection<object> nl, Collection<object> H)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
            
        try
        {
            Collection<int> PlayerNamesN = (Collection<int>)I[1];
            
            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            Tour TheTour = new Tour(parsed, PlayerNamesN);

            Collection<Tour> Tours = (Collection<Tour>)H[1];
            Tours.Add(TheTour);

            ret.Add(Tours);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> H2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
            
        try
        {
            ret.Add(new Collection<Tour>());
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> H3(Collection<object> n1, Collection<object> nl, Collection<object> H)
    {
        return H;
    }

    public Collection<object> I1(Collection<object> n1, Collection<object> n2, Collection<object> I)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
            
        try
        {
            Collection<int> Numbers = (Collection<int>)I[1];

            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            Numbers.Add(parsed);

            ret.Add(Numbers);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> I2(Collection<object> n1)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
            
        try
        {
            Collection<int> Numbers = new Collection<int>();

            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            Numbers.Add(parsed);

            ret.Add(Numbers);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> w(Collection<object> W, Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
         
        try
        {
            ret.Add((string)W[0] + (string)s[1]);
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

    public Collection<object> EmailWord1(Collection<object> w1, Collection<object> s, Collection<object> w2)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
            
        try
        {
            ret.Add((string)w1[1]+"@"+(string)w2[1]);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> DateWord1(Collection<object> w1, Collection<object> s, Collection<object> w2, Collection<object> s1, Collection<object> w3)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
            
        try
        {
            ret.Add((string)w1[0] + "." + (string)w2[0] + "." + (string)w3[0]);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        return ret;
    }

    public Collection<object> DateWord2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        return ret;
    }

    public Collection<object> nE1(Collection<object> n)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        return ret;
    }

    public Collection<object> nE2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        return ret;
    }


    public Collection<object> s1(Collection<object> p)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        
        return ret;
    }

    public Collection<object> s2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        return ret;
    }

}
