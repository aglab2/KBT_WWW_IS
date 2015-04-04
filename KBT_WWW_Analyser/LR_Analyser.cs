using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Text;

namespace KBT_WWW_IS
{
    
    [System.Serializable]
    public class lr_table_string
    {
        public Dictionary<symbol, Act> Action = new Dictionary<symbol, Act>();
        public Dictionary<symbol, int> Goto = new Dictionary<symbol, int>();
    }

    [System.Serializable]
    public class Act
    {
        public char type;
        public rule rule;

        public Act(char t)
        {
            type = t;
            rule = null;
        }

        public Act(char t, rule r)
        {
            type = t;
            rule = r;
        }
    }

    [System.Serializable]   
    public class lr_table : Collection<lr_table_string> { }

    [System.Serializable]   
    public class LR_Rule_Seq: Stack<rule>
    {
    }

    [System.Serializable]
    class LR_Analyser
    {
        public static LR_Rule_Seq Analyse(lr_table table, Queue<Tuple<symbol, int, int, int>> str, rule_table rules, string FileName)
        {
            Tuple<symbol, int, int, int> lsym = null;
            int cur_st = 0;
            try
            {
                str.Enqueue(Tuple.Create(new symbol(LR_Builder.EndSymbol), 0, 0, 0));

                LR_Rule_Seq parsed = new LR_Rule_Seq();
                lsym = str.Dequeue();
                symbol cur = lsym.Item1;
                Stack buff = new Stack();
                buff.Push(0);
                while (true)
                {
                    Act act = null;
                    cur_st = (int)buff.Pop();
                    try
                    {
                        act = table[cur_st].Action[cur];
                    }
                    catch (KeyNotFoundException)
                    {
                        throw new Exception("ACTION");
                    }
                    if (act.type == 'A')
                    {
                        return parsed;
                    }
                    else if (act.type == 'S')
                    {
                        buff.Push(cur_st);
                        buff.Push(cur);
                        try
                        {
                            buff.Push(table[cur_st].Goto[cur]);
                        }
                        catch (KeyNotFoundException)
                        {
                            throw new Exception("GOTO");
                        }
                        lsym = str.Dequeue();
                        cur = lsym.Item1;
                        try
                        {
                        }
                        catch (Exception) { Console.WriteLine(); }
                    }
                    else if (act.type == 'R')
                    {
                        symbol rule_l = act.rule.A;
                        symbol_string rule_r = act.rule.rule_l.str;

                        parsed.Push(act.rule);
                        if (rule_r != "")
                        {
                            for (int i = 0; i < 2 * rule_r.Count - 1; i++)
                                buff.Pop();
                            cur_st = (int)buff.Pop();
                        }
                        buff.Push(cur_st);
                        buff.Push(rule_l);
                        try
                        {
                            buff.Push(table[cur_st].Goto[rule_l]);
                        }
                        catch (KeyNotFoundException)
                        {
                            throw new Exception("GOTO");
                        }
                    }
                    else
                    {
                        throw new Exception("Unknown command!");
                    }
                }
           }
           catch (Exception E)
           {
               using (var sr = new StreamReader(FileName, Encoding.GetEncoding(1251)))
               {
                   var color = Console.ForegroundColor;
                   Console.ForegroundColor = ConsoleColor.Red;
                   Console.Error.WriteLine("Error in file {0} in line {1}", FileName, lsym.Item2);
                   Console.ForegroundColor = color;
                   for (int i = 1; i < lsym.Item2; i++)
                       sr.ReadLine();
                   Console.Error.WriteLine(sr.ReadLine());
                   for (int i = 0; i < lsym.Item3; i++)
                       Console.Error.Write(" ");
                   for (int i = 0; i < lsym.Item4 - lsym.Item3; i++)
                       Console.Error.Write("^");
                   Console.Error.WriteLine();
                   Console.Error.Write("Found symbol {0} but expected", lsym.Item1);
                   if (E.Message == "GOTO")
                   {
                       foreach (symbol s in table[cur_st].Action.Keys)
                       {
                           Console.Error.Write(" " + s);
                       }
                   }
                   else if (E.Message == "ACTION")
                   {
                       foreach (symbol s in table[cur_st].Action.Keys)
                       {
                           Console.Error.Write(" " + s);
                       }
                   }
                   else
                   {
                       Console.Error.WriteLine("Something unexpected happened! Message: " + E.Message);
                   }
                   Console.Error.WriteLine();
                   Console.Error.WriteLine();
                   Console.Error.WriteLine();
               }
               return null;
           }
        }

        public static WordTree Treefy(rule_table rules, LR_Rule_Seq parsed)
        {
            WordTree retval = new WordTree();
            retval.start = new Node(rules.S);
            Node ret = retval.start;
            Collection<Node> senform = new Collection<Node>(); //Reversed!
            senform.Add(ret);

            while (parsed.Count != 0)
            {
                rule rule = parsed.Pop();
                symbol rule_l = rule.A;
                symbol_string rule_r = rule.rule_l.str;
                for (int i = 0; i < senform.Count; i++)
                {
                    if (senform[i].Name.A == rule_l)
                    {
                        Node changed = senform[i];
                        changed.Name.rule_l = rule.rule_l;
                        changed.link = new NodeLink();
                        NodeLink newnode = changed.link;
                        senform.RemoveAt(i);
                        foreach (symbol sym in rule_r)
                        {
                            Node newlink = new Node(new symbol(sym));
                            newnode.Add(newlink);
                            if (sym != symbol.e)
                                senform.Insert(i, newlink);
                        }
                        break;
                    }
                }
            }

            return retval;
        }
    }
}
