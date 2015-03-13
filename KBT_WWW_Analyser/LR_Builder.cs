using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Security.Permissions;
using System.Reflection;

namespace KBT_WWW_IS
{
    [System.Serializable]
    class first: HashSet<symbol> { }

    [System.Serializable]
    class first_array : Dictionary<symbol, HashSet<symbol>> { }

    [System.Serializable]
    class LR_Builder
    {
        static public string EndSymbol = "EndSymbol",
                               StarterN = "StarterN";

        class LR_Case
        {
            public rule rule;
            public int dotp;
            public symbol avan;

            public LR_Case(rule r, symbol avan)
            {
                this.rule = r;
                this.dotp = 0;
                this.avan = avan;
            }

            public LR_Case(rule r, symbol avan, int dotp)
            {
                this.rule = r;
                this.dotp = dotp;
                this.avan = avan;
            }

            public symbol_string adot
            {
                get { return rule.rule_l.str.Substring(dotp);  }
            }

            public override bool Equals(object obj)
            {
                LR_Case lc = obj as LR_Case;
                if (lc == null) return false;

                if (this.dotp != lc.dotp) return false;
                if (!this.rule.Equals(lc.rule)) return false;
                return this.avan == lc.avan;
            }

            public override int GetHashCode()
            {
                return this.dotp.GetHashCode() ^ this.rule.GetHashCode() ^ this.avan.GetHashCode();
            }

            public void Debug()
            {
                Console.ForegroundColor = ConsoleColor.Gray;
                Console.Write(this.rule);
                Console.Write(" , ");
                Console.ForegroundColor = ConsoleColor.Red;
                Console.Write(this.avan);
                Console.Write(" - ");
                Console.ForegroundColor = ConsoleColor.Cyan;
                Console.WriteLine(this.adot);
                Console.ForegroundColor = ConsoleColor.Gray;
            }
        }

        [System.Serializable]
        class LR_Dcase
        {
            public Collection<LR_Case> cases = new Collection<LR_Case>();
            public Dictionary<symbol, int> link = new Dictionary<symbol, int>();

            public void Debug()
            {
                foreach (LR_Case lc in cases)
                {
                    lc.Debug();
                }
            }
        }

        public static first first_string(symbol_string rl, first_array FIRST, rule_table rules)
        {
            first ret = new first();
            int i = 0;
            bool nonstop = true;
            if (rl != "")
            {
                while (i < rl.Count && nonstop)
                {
                    symbol Yi = rl[i];
                    if (FIRST[Yi].Contains(symbol.e))
                    {
                        FIRST[Yi].Remove(symbol.e);
                        ret.UnionWith(FIRST[Yi]);
                        FIRST[Yi].Add(symbol.e);
                        i++;
                    }
                    else
                    {
                        nonstop = false;
                        ret.UnionWith(FIRST[Yi]);
                    }
                }
                if (nonstop) ret.Add(symbol.e);
            }
            return ret;
        }

        public static lr_table Builder(rule_table rules)
        {
            rules.T.Add(new symbol(EndSymbol));

            lr_table ret = new lr_table();

            first_array FIRST = first(rules);

            rules.lrS = new symbol(StarterN); //TODO
            rules.N.Add(rules.lrS);
            rule rule = rules.Add_Rule(rules.lrS, new symbol_string(rules.S), null, null); 

            LR_Dcase dcase = new LR_Dcase();
            LR_Case start = new LR_Case(rule, new symbol(EndSymbol));
            
            dcase.cases.Add(start);

            LR_Closure(dcase, rules, FIRST);

            Collection<LR_Dcase> all = new Collection<LR_Dcase>();
            all.Add(dcase);

            LR_Recurs_Add(dcase, FIRST, rules, all);
            foreach(LR_Dcase dcase_i in all)
            {
                lr_table_string new_str = new lr_table_string();
                foreach (LR_Case cas in dcase_i.cases)
                {
                    try
                    {
                        if (cas.adot == "")//Reduce rule
                        {
                            if (cas.rule.A == StarterN)//Accept rule
                            {
                                Act newact = new Act('A');
                                new_str.Action.Add(cas.avan, newact);
                            }
                            else
                            {
                                Act newact = new Act('R', cas.rule);
                                new_str.Action.Add(cas.avan, newact);
                            }
                        }
                        else if (rules.T.Contains(cas.adot[0]))//Shift rule
                        {
                            foreach (symbol sym in first_string(cas.adot + cas.avan, FIRST, rules))
                            {
                                if (!new_str.Action.Keys.Contains(sym))
                                {
                                    Act newact = new Act('S');
                                    new_str.Action.Add(sym, newact);
                                }
                                else
                                {
                                    if (new_str.Action[sym].type != 'S') //Many Shifts - OK, Not Shift - NO
                                    {
                                        throw new Exception("S+R conflict");
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception)
                    {
                        Console.WriteLine("Your grammar is not LR(1). Here are debug info for you");
                        cas.Debug();
                        Console.WriteLine("-----");
                        dcase_i.Debug();
                        return null;
                    }
                }
                foreach (symbol A in dcase_i.link.Keys) //Goto table
                {
                    new_str.Goto.Add(A, dcase_i.link[A]);
                }
                ret.Add(new_str);
            }
            
            return ret;
        }

        static void LR_Closure(LR_Dcase dcase, rule_table rules,  first_array FIRST)
        {
            for (int i = 0; i < dcase.cases.Count; i++) //No foreach as dcases.cases updates
            {
                LR_Case cur_case = dcase.cases[i];
                if (cur_case.adot != ""){
                    if (rules.N.Contains(cur_case.adot[0]))
                    {
                        symbol new_A = cur_case.adot[0];
                        if (rules.Keys.Contains(new_A))
                        {
                            foreach (rule_l rulee in rules[new_A])
                            {
                                symbol_string rule = rulee.str;
                                first new_avan = first_string(cur_case.adot.Substring(1) + cur_case.avan, FIRST, rules);
                                foreach (symbol avan in new_avan)
                                {
                                    rule r = new rule(new_A, rulee);
                                    LR_Case new_case = new LR_Case(r, avan);
                                    if (!dcase.cases.Contains(new_case))
                                    {
                                        dcase.cases.Add(new_case);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            dcase.cases.OrderBy(i => i); //To check if two DCases are Equal we need them to be sorted
        }

        static void LR_Recurs_Add(LR_Dcase dcase, first_array FIRST, rule_table rules, Collection<LR_Dcase> all)
        {
            Dictionary<symbol, LR_Dcase> cand = new Dictionary<symbol, LR_Dcase>();
            foreach (LR_Case cur_case in dcase.cases)
            {
                if (cur_case.adot != "")
                {
                    symbol cur_char = cur_case.adot[0];
                    LR_Case new_case = new LR_Case(cur_case.rule, cur_case.avan, cur_case.dotp+1);

                    if (!cand.Keys.Contains(cur_char))
                        cand.Add(cur_char, new LR_Dcase());
                    cand[cur_char].cases.Add(new_case);
                }
            }

            foreach (symbol A in cand.Keys)
            {
                LR_Dcase cur_case = cand[A];
                LR_Closure(cur_case, rules, FIRST);
                bool eq = false;
                int ret = -1;
                foreach (LR_Dcase dcase_i in all)
                {
                    ret++;
                    if (dcase_i.cases.SequenceEqual(cur_case.cases))
                    {
                        eq = true;
                        break;
                    }
                }
                if (!eq)
                {
                    all.Add(cur_case);
                    dcase.link[A] = all.IndexOf(cur_case);
                }
                else
                {
                    dcase.link[A] = ret;
                }
                if (!eq)
                    LR_Recurs_Add(cur_case, FIRST, rules, all);
            }
        }

        public static first_array first(rule_table rules)
        {
            first_array FIRST = new first_array();

            foreach (symbol c in rules.T)
            {
                FIRST.Add(c, new first());
                FIRST[c].Add(c);
            }

            foreach (symbol S in rules.Keys)
            {
                FIRST.Add(S, new first());
                foreach (var rll in rules[S])
                {
                    symbol_string rl = rll.str;
                    if (rl == symbol.e)
                    {
                        FIRST[S].Add(symbol.e);
                    }
                }
            }
            
            bool cont = false;
            do{
                cont = false;
                foreach (symbol X in rules.Keys)
                {
                    foreach (var rll in rules[X])
                    {
                        symbol_string rl = rll.str;
                        int i = 0;
                        bool nonstop = true;
                        if (rl != symbol.e)
                        {
                            while (i < rl.Count && nonstop)
                            {
                                symbol Yi = rl[i];
                                if (FIRST[Yi].Contains(symbol.e))
                                {
                                    FIRST[Yi].Remove(symbol.e);
                                    if (!FIRST[Yi].IsSubsetOf(FIRST[X]))
                                    {
                                        cont = true;
                                        FIRST[X].UnionWith(FIRST[Yi]);
                                    }
                                    FIRST[Yi].Add(symbol.e);
                                    i++;
                                }
                                else
                                {
                                    nonstop = false;
                                    if (!FIRST[Yi].IsSubsetOf(FIRST[X]))
                                    {
                                        cont = true;
                                        FIRST[X].UnionWith(FIRST[Yi]);
                                    }
                                }
                            }
                            if (nonstop)
                            {
                                if (!FIRST[X].Contains(symbol.e))
                                {
                                    FIRST[X].Add(symbol.e);
                                    cont = true;
                                }
                            }
                        }
                    }
                }
            }while(cont);

            return FIRST;
        }
    }
}
