using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
        public string phone;

        public Team()
        {
            this.global_id = "";
            this.name = "";
            this.email = "";
            this.city = "";
            this.age_category = "";
            this.phone = "";
        }
    }

    class Player
    {
        public int num;
        public string team_global_id;
        public string name;
        public string bday;
        public string is_captain;
        public string is_legioner;
        public string rate_id;

        public Player(int num, string name, string bday, string is_captain, string is_legioner, string rate_id)
        {
            this.num = num;
            this.team_global_id = "";
            this.name = name;
            this.bday = bday;
            this.is_captain = is_captain;
            this.is_legioner = is_legioner;
            this.rate_id = rate_id;
        }
    }

    class Tour
    {
        public int num;
        public Collection<int> playernums;
        public Collection<Player> players = new Collection<Player>();

        public Tour(int num, Collection<int> playernums)
        {
            this.num = num;
            this.playernums = playernums;
        }
    }

    const string city = "Москва";

    public Collection<object> S1(Collection<object> w0, Collection<object> w1, Collection<object> k1, Collection<object> w2, Collection<object> k2,
         Collection<object> w3, Collection<object> nl, Collection<object> E)
    { 
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Team TheTeam = (Team)E[1];
        Collection<Player> Players = (Collection<Player>)E[2];
        Collection<Tour> Tours = (Collection<Tour>)E[3];

        string RegCardNumber = (string)w0[0];
        RegCardNumber = RegCardNumber.Remove(RegCardNumber.Length - 2);
        string TournamentName = (string)w1[1];
        string TeamTournamentPassword = (string)w2[0];


        Collection<Tuple<string, string>> arg = new Collection<Tuple<string, string>>();
        Tuple<string, Collection<Tuple<string, string>>> comm = new Tuple<string, Collection<Tuple<string, string>>>("addTournament", arg);
        arg.Add(Tuple.Create("@city", city));
        arg.Add(Tuple.Create("@name", TournamentName));
        arg.Add(Tuple.Create("@password", TeamTournamentPassword));
        ret.Add(comm);

        arg = new Collection<Tuple<string, string>>();
        comm = new Tuple<string, Collection<Tuple<string, string>>>("addTeam", arg);
        arg.Add(Tuple.Create("@name", TheTeam.name));
        arg.Add(Tuple.Create("@phone", TheTeam.phone));
        arg.Add(Tuple.Create("@email", TheTeam.email));
        arg.Add(Tuple.Create("@city", TheTeam.city));
        ret.Add(comm);


        arg = new Collection<Tuple<string, string>>();
        comm = new Tuple<string, Collection<Tuple<string, string>>>("addTeam2Tournament", arg);
        arg.Add(Tuple.Create("@team_name", TheTeam.name));
        arg.Add(Tuple.Create("@tournament_name", TournamentName));
        arg.Add(Tuple.Create("@tournament_city", city));
        arg.Add(Tuple.Create("@regcard_number", RegCardNumber));
        ret.Add(comm);

        arg = new Collection<Tuple<string, string>>();
        comm = new Tuple<string, Collection<Tuple<string, string>>>("addAgeCategory2TeamTournament", arg);
        arg.Add(Tuple.Create("@team_name", TheTeam.name));
        arg.Add(Tuple.Create("@tournament_name", TournamentName));
        arg.Add(Tuple.Create("@tournament_city", city));
        arg.Add(Tuple.Create("@regcard_number", RegCardNumber));
        arg.Add(Tuple.Create("@age_category", TheTeam.age_category)); 
        
        ret.Add(comm);


        /* обработка ситуаций, когда капитан явно не указан/проверка, что капитанов не более одного */
        // в этом формате отчетов все игроки образуют команду
        int cap_number = 0;
        foreach (var Player in Players)
            if (Player.is_captain == true.ToString())
                cap_number++;
        
        if (cap_number > 1)
        {
            ret[0] = new Exception("More than one capitan!");
            return ret;
        }

        if (Players.Count > 0 && cap_number == 0) Players[Players.Count - 1].is_captain = true.ToString();
        /* ----------------------------------------------------------------------------------------- */


        foreach (var Player in Players)
        {
            arg = new Collection<Tuple<string, string>>();
            comm = new Tuple<string, Collection<Tuple<string, string>>>("addPlayer", arg);
            arg.Add(Tuple.Create("@rate_id", Player.rate_id));
            if (Player.is_legioner != true.ToString())
                arg.Add(Tuple.Create("@team_name", TheTeam.name));
            arg.Add(Tuple.Create("@name", Player.name));
            arg.Add(Tuple.Create("@birthday", Player.bday));
            arg.Add(Tuple.Create("@is_captain", Player.is_captain));
            arg.Add(Tuple.Create("@is_legioner", Player.is_legioner));
            ret.Add(comm);


            arg = new Collection<Tuple<string, string>>();
            comm = new Tuple<string, Collection<Tuple<string, string>>>("addPlayer2Season", arg);
            arg.Add(Tuple.Create("@player_name", Player.name));
            arg.Add(Tuple.Create("@player_birthday", Player.bday));
            /*
            arg.Add(Tuple.Create("@season_year", city));
            arg.Add(Tuple.Create("@schoolgrade", TeamTournamentPassword)); //CORRECT???
            */
            ret.Add(comm);
        }

        foreach (var Tour in Tours)
        {
            foreach (var Player in Tour.players)
            {
                arg = new Collection<Tuple<string, string>>();
                comm = new Tuple<string, Collection<Tuple<string, string>>>("addPlayer2GameRound", arg);
                arg.Add(Tuple.Create("@player_name", Player.name));
                arg.Add(Tuple.Create("@player_birthday", Player.bday));
                arg.Add(Tuple.Create("@player_team_name", TheTeam.name));
                arg.Add(Tuple.Create("@tour_number", Tour.num.ToString()));
                arg.Add(Tuple.Create("@tournament_name", TournamentName));
                arg.Add(Tuple.Create("@tournament_city", city));
                if (Player.is_legioner == true.ToString())
                    arg.Add(Tuple.Create("@is_legioner", Player.is_legioner));
                ret.Add(comm);
            }
        }

        return ret;
    }

    public Collection<object> D(Collection<object> W1, Collection<object> c1, Collection<object> W2, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Team TheTeam = (Team)E[1];
        Collection<Player> Players = (Collection<Player>)E[2];
        Collection<Tour> Tours = (Collection<Tour>)E[3];

        string doubledeclare = null;
        string title = ((string)W1[1]).Trim();

        if (title == "Название команды")
        {
            if (TheTeam.name == "") TheTeam.name = (string)W2[1];
            else doubledeclare = (string)W1[1];
        }
        else if (title == "Возрастная категория")
        {
            if (TheTeam.age_category == "") TheTeam.age_category = (string)W2[1];
            else doubledeclare = (string)W1[1]; //TODO
        }
        else if (title == "Город")
        {
            if (TheTeam.city == "") TheTeam.city = (string)W2[1];
            else doubledeclare = (string)W1[1];
        }
        else if (title == "ID в рейтинге")
        {
            if (TheTeam.global_id == "") TheTeam.global_id = (string)W2[1];
            else doubledeclare = (string)W1[1];
        }

        if (doubledeclare != null)
            ret[0] = new Exception("Double DECLARE! " + doubledeclare);

        ret.Add(TheTeam);
        ret.Add(Players);
        ret.Add(Tours);
        return ret;
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

        Team TheTeam = (Team)E[1];
        Collection<Player> Players = (Collection<Player>)E[2];
        Collection<Tour> Tours = (Collection<Tour>)E[3];

        try
        {
            //Email/тел.
            if ((string)w1[0] == "Email" && (string)w2[0] == "тел")
            {
                TheTeam.phone = (string)Phone[1];
                TheTeam.email = (string)EmailWord[1];
            }
            else throw new Exception("Wrong e-mail/phone description!!!");
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        ret.Add(TheTeam);
        ret.Add(Players);
        ret.Add(Tours);

        return ret;
    }

    public Collection<object> Email2(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1,
        Collection<object> c1, Collection<object> EmailWord, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Team TheTeam = (Team)E[1];
        Collection<Player> Players = (Collection<Player>)E[2];
        Collection<Tour> Tours = (Collection<Tour>)E[3];

        try
        {
            //Email/тел.
            if ((string)w1[0] == "Email" && (string)w2[0] == "тел")
            {
                TheTeam.email = (string)EmailWord[1];
            }
            else throw new Exception("Wrong e-mail/phone description!!!");
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        ret.Add(TheTeam);
        ret.Add(Players);
        ret.Add(Tours);

        return ret;
    }

    public Collection<object> Email3(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1,
    Collection<object> c1, Collection<object> nl, Collection<object> E)
    {
        return E;
    }

    public Collection<object> Email5(Collection<object> w1, Collection<object> s1, Collection<object> w2, Collection<object> d1,
    Collection<object> c1, Collection<object> Phone, Collection<object> w3, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Team TheTeam = (Team)E[1];
        Collection<Player> Players = (Collection<Player>)E[2];
        Collection<Tour> Tours = (Collection<Tour>)E[3];

        try
        {
            //Email/тел.
            if ((string)w1[0] == "Email" && (string)w2[0] == "тел")
            {
                TheTeam.phone = (string)Phone[1];
            }
            else throw new Exception("Wrong e-mail/phone description!!!");
        }
        catch (Exception e)
        {
            ret[0] = e;
        }

        ret.Add(TheTeam);
        ret.Add(Players);
        ret.Add(Tours);

        return ret;
    }

    public Collection<object> E(Collection<object> W1, Collection<object> c1, Collection<object> W2, Collection<object> nl, Collection<object> E)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Team TheTeam = (Team)E[1];
        Collection<Player> Players = (Collection<Player>)E[2];
        Collection<Tour> Tours = (Collection<Tour>)E[3];

        string doubledeclare = null;
        string title = ((string)W1[1]).Trim();

        if (title == "Название команды")
        {
            if (TheTeam.name == "") TheTeam.name = (string)W2[1];
            else doubledeclare = (string)W1[1];
        }
        else if (title == "Возрастная категория")
        {
            if (TheTeam.age_category == "") TheTeam.age_category = (string)W2[1];
            else doubledeclare = (string)W1[1]; //TODO
        }
        else if (title == "Город")
        {
            if (TheTeam.city == "") TheTeam.city = (string)W2[1];
            else doubledeclare = (string)W1[1];
        }
        else if (title == "ID в рейтинге")
        {
            if (TheTeam.global_id == "") TheTeam.global_id = (string)W2[1];
            else doubledeclare = (string)W1[1];
        }

        if (doubledeclare != null)
            ret[0] = new Exception("Double DECLARE! " + doubledeclare);

        ret.Add(TheTeam);
        ret.Add(Players);
        ret.Add(Tours);
        return ret;
    }

    public Collection<object> E2(Collection<object> W1, Collection<object> c1, Collection<object> nl, Collection<object> E)
    {
        return E;
    }

    public Collection<object> NextP(Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(new Team());
        ret.Add(P[1]);
        ret.Add(P[2]);
        return ret;
    }

    public Collection<object> P1(Collection<object> s1, Collection<object> n1, Collection<object> Name,
        Collection<object> c1, Collection<object> Space, Collection<object> Date, Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

            Collection<Player> Players = (Collection<Player>)P[1];
            Collection<Tour> Tours = (Collection<Tour>)P[2];

            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            
            Player ThePlayer = new Player(parsed, (string)Name[1], (string)Date[1], false.ToString(), false.ToString(), "");
            Players.Add(ThePlayer);

            foreach (Tour t in Tours)
                if (t.playernums.Contains(ThePlayer.num))
                    t.players.Add(ThePlayer);
            
            ret.Add(Players);
            ret.Add(Tours);
        
        return ret;
    }

    public Collection<object> P2(Collection<object> s1, Collection<object> n1, Collection<object> Name,
    Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        Collection<Player> Players = (Collection<Player>)P[1];
        Collection<Tour> Tours = (Collection<Tour>)P[2];

        int parsed = 0;
        int.TryParse((string)n1[0], out parsed);

        Player ThePlayer = new Player(parsed, (string)Name[1], "", false.ToString(), false.ToString(), "");
        Players.Add(ThePlayer);

        foreach (Tour t in Tours)
            if (t.playernums.Contains(ThePlayer.num))
                t.players.Add(ThePlayer);

        ret.Add(Players);
        ret.Add(Tours);

        return ret;
    }


    public Collection<object> P6(Collection<object> sym, Collection<object> s1, Collection<object> n1, Collection<object> Name,
        Collection<object> c1, Collection<object> p4, Collection<object> Date, Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            Collection<Player> Players = (Collection<Player>)P[1];
            Collection<Tour> Tours = (Collection<Tour>)P[2];

            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            bool is_capitan = ((string)sym[0] == "+" || (string)sym[0] == "К" || (string)sym[0] == "K" || (string)sym[0] == "k" || (string)sym[0] == "к") ? true : false;
            bool is_legioner = ((string)sym[0] == "л" || (string)sym[0] == "Л" || (string)sym[0] == "$") ? true : false;

            Player ThePlayer = new Player(parsed, (string)Name[1], (string)Date[1], is_capitan.ToString(), is_legioner.ToString(), "");

            foreach (Tour t in Tours)
            {
                if (t.playernums.Contains(ThePlayer.num))
                    t.players.Add(ThePlayer);
            }
            
            if (is_capitan)
                foreach (var Vasya in Players)
                    if (Vasya.is_captain == is_capitan.ToString()) throw new Exception("More than one capitan!");

            Players.Add(ThePlayer);

            ret.Add(Players);
            ret.Add(Tours);
        }
        catch (Exception e)
        {
            ret[0] = e;
        }
        return ret;
    }

    public Collection<object> P9(Collection<object> sym, Collection<object> s1, Collection<object> n1, Collection<object> Name,
    Collection<object> nl, Collection<object> P)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);

        try
        {
            Collection<Player> Players = (Collection<Player>)P[1];
            Collection<Tour> Tours = (Collection<Tour>)P[2];

            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            bool is_capitan = ((string)sym[0] == "+" || (string)sym[0] == "К" || (string)sym[0] == "K" || (string)sym[0] == "k" || (string)sym[0] == "к") ? true : false;
            bool is_legioner = ((string)sym[0] == "л" || (string)sym[0] == "Л" || (string)sym[0] == "$") ? true : false;

            Player ThePlayer = new Player(parsed, (string)Name[1], "", is_capitan.ToString(), is_legioner.ToString(), "");

            foreach (Tour t in Tours)
            {
                if (t.playernums.Contains(ThePlayer.num))
                    t.players.Add(ThePlayer);
            }

            if (is_capitan)
                foreach (var Vasya in Players)
                    if (Vasya.is_captain == is_capitan.ToString()) throw new Exception("More than one capitan!");

            Players.Add(ThePlayer);

            ret.Add(Players);
            ret.Add(Tours);
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

            Collection<Player> Players = (Collection<Player>)P[1];
            Collection<Tour> Tours = (Collection<Tour>)P[2];

            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            Player ThePlayer = new Player(parsed, (string)Name[1], (string)Date[1], false.ToString(), false.ToString(), (string)nE[1]);
            Players.Add(ThePlayer);

            foreach (Tour t in Tours)
                if (t.playernums.Contains(ThePlayer.num))
                    t.players.Add(ThePlayer);

            ret.Add(Players);
            ret.Add(Tours);
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
            Collection<Player> Players = (Collection<Player>)P[1];
            Collection<Tour> Tours = (Collection<Tour>)P[2];

            int parsed = 0;
            int.TryParse((string)n1[0], out parsed);
            bool is_capitan = ((string)sym[0] == "+" || (string)sym[0] == "К" || (string)sym[0] == "K" || (string)sym[0] == "k" || (string)sym[0] == "к") ? true : false;
            bool is_legioner = ((string)sym[0] == "л" || (string)sym[0] == "Л" || (string)sym[0] == "$") ? true : false;
            Player ThePlayer = new Player(parsed, (string)Name[1], (string)Date[1], is_capitan.ToString(), is_legioner.ToString(), (string)n5[1]);

            foreach (Tour t in Tours)
                if (t.playernums.Contains(ThePlayer.num))
                    t.players.Add(ThePlayer);

            // check bug
            if (is_capitan)
            foreach (var Vasya in Players)
                if (Vasya.is_captain == is_capitan.ToString()) throw new System.Exception("More than one captain!");

            Players.Add(ThePlayer);

            ret.Add(Players);
            ret.Add(Tours);
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


    public Collection<object> NextH(Collection<object> H)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add(new Collection<Player>());
        ret.Add(H[1]);

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

            while (PlayerNamesN[0] > 10)
            {
                PlayerNamesN.Add(PlayerNamesN[0] % 10);
                PlayerNamesN[0] /= 10;
            }

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
            ret.Add((string)w1[1]+(string)s[0]+(string)w2[1]);
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
        ret.Add("");
        
        return ret;
    }

    public Collection<object> nE1(Collection<object> n)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add((string)n[0]);

        return ret;
    }

    public Collection<object> nE2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add("");
        
        return ret;
    }


    public Collection<object> s1(Collection<object> p)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add("");
        
        return ret;
    }

    public Collection<object> s2()
    {
        Collection<object> ret = new Collection<object>();
        ret.Add(null);
        ret.Add("");
        
        return ret;
    }

}
