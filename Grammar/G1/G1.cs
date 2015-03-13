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
        public string global_id;
        public string name;
        public string email;
        public string city;

        public Team(string global_id, string name, string email, string city)
        {
            this.global_id = global_id;
            this.name = name;
            this.email = email;
            this.city = city;
        }
    }

    class Player
    {
        public string team_global_id;
        public string name;
        public string bday;
        public string is_captain;

        public Player(string team_id, string name, string bday, string is_captain)
        {
            this.team_global_id = team_id;
            this.name = name;
            this.bday = bday;
            this.is_captain = is_captain;
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
        Collection<object> ret = new Collection<object>();
		ret.Add(null);
        return ret;
    }

    public Collection<object> D(Collection<object> W1, Collection<object> c1, Collection<object> W2, Collection<object> nl, Collection<object> D)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> D1(Collection<object> W1, Collection<object> c1, Collection<object> p2, Collection<object> nl, Collection<object> D)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> D2(Collection<object> W1, Collection<object> c1, Collection<object> nl, Collection<object> D)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> Email1(Collection<object> w1, Collection<object> s1, Collection<object> w2,
    Collection<object> d1, Collection<object> c1, Collection<object> w3, 
        Collection<object> dd3, Collection<object> ww5, Collection<object> d3, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> Email2(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1, 
        Collection<object> c1, Collection<object> w4, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> Email3(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1,
    Collection<object> c1, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> Email5(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1,
    Collection<object> c1, Collection<object> ww, Collection<object> w3, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> E(Collection<object> W1, Collection<object> c1, Collection<object> W2, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> E1(Collection<object> W1, Collection<object> c1, Collection<object> p2, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> E2(Collection<object> W1, Collection<object> c1, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> NextP(Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> P1(Collection<object> s1, Collection<object> n1, Collection<object> Name, 
        Collection<object> c1, Collection<object> Date, Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<Player> caps;

        if (P.Count < 2)
        {
            caps = new Collection<Player>();
        }
        else
        {
            caps = (Collection<Player>)P[1];
        }


        try
        {
            caps.Add(new Player(null, (string)Name[1], (string)Date[1], ""));
            ret.Add(caps);
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
        return ret;
    }

    public Collection<object> P4(Collection<object> s1, Collection<object> n1, Collection<object> Name,
        Collection<object> c1, Collection<object> s2, Collection<object> Date, Collection<object> c2, 
        Collection<object> s3, Collection<object> nE, Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> P7(Collection<object> sym, Collection<object> s1, Collection<object> n1, Collection<object> Name,
        Collection<object> c1, Collection<object> p8, Collection<object> Date, Collection<object> c2, Collection<object> p4, Collection<object> n5,
        Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        try
        {
            ret.Add(null);

        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> P3(Collection<object> s1, Collection<object> n1, Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        try
        {
            ret.Add(null);
            Collection<Player> Player = new Collection<Player>(); // TODO!
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }


    public Collection<object> Q1(Collection<object> s, Collection<object> n1, Collection<object> nl, Collection<object> Q)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> NextH(Collection<object> H)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> H1(Collection<object> n1, Collection<object> p, Collection<object> I, Collection<object> nl, Collection<object> H)
    {
        Collection<object> ret = new Collection<object>();
        try
        {
            ret.Add(null);
            Collection<int> PlayerNamesN = (Collection<int>)I[1];
            
            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            Collection<Tour> Tour = new Collection<Tour>(parsed, PlayerNamesN);

            Collection<Tour> Tours = (Collection<int>)H[1];
            Tours.Add(Tour);

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
        try
        {
            ret.Add(null);
            ret.Add(Collection<Tour>());
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

        try
        {
            ret.Add(null);
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

        try
        {
            ret.Add(null);
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

        try
        {
            ret.Add(null);
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

        try
        {
            ret.Add(null);
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
        
        try
        {
            ret.Add(null);
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
