using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Diagnostics;
using System.Collections.ObjectModel;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO.Compression;

namespace KBT_WWW_IS
{
    [System.Serializable]
    class GAnalyser
    {
        rule_table rules;
        lr_table LRTable;

        public GAnalyser(string XMLGrammarFile)
        {
            rules = XMLStorage.ImportXMLGrammar(XMLGrammarFile);
            
            if (rules == null)
            {
                throw new System.Exception("Bad input Grammar file(XML structure) " + XMLGrammarFile);
            }
            
            LRTable = LR_Builder.Builder(rules);
            if (LRTable == null)
            {
                throw new System.Exception("Bad input Grammar(bad grammar/not LR(1)) " + XMLGrammarFile);
            }
        }

        public bool ProcessFile(string path, string server)
        {
            Debug.Assert(AllIsOk() == true);

            Queue<Tuple<symbol, int, int, int>> lex_queue = Lexer_t.ProcessFile(path, rules);
            Debug.Assert(lex_queue != null);

            try
            {
                Console.WriteLine("\n-------------------- "+path+" ----------------\n");
                LR_Rule_Seq parsed = LR_Analyser.Analyse(LRTable, lex_queue, rules, path);

                if (parsed == null) return false;
                
                WordTree tree = LR_Analyser.Treefy(rules, parsed);
                Debug.Assert(tree != null);

                Queue<Tuple<symbol, int, int, int>> wattr = Lexer_t.ProcessFile(path, rules);
                Debug.Assert(wattr != null);

                List<symbol> word = tree.word();
                Debug.Assert(word != null);

                foreach (symbol c in word)
                {
                    c.attr = wattr.Dequeue().Item1.attr;
                }

                //tree.PrintPretty("", true);
                
                Collection<object> att = tree.attrib();
                Debug.Assert(att != null);

                SQLCommander sc = new SQLCommander(server);
                foreach (object o in att)
                {
                    if (o == null) continue;
                    Tuple<string, Collection<Tuple<string, string>>> comm = o as Tuple<string, Collection<Tuple<string, string>>>;
                    if (comm == null){
                        Console.WriteLine("Fuck you, your atributes shall return Tuple<string, Collection<Tuple<string, string>>>");
                    }

                    sc.Execute(comm.Item1, comm.Item2);
                    //Console.WriteLine(o);
                }
                
                return true;
            }
            catch (Exception e)
            {
                Console.Error.WriteLine(e.ToString());
                return false;
            }
        }

        public Dictionary<string, bool> ProcessDirRec(string path, string server)
        {
            Debug.Assert(AllIsOk() == true);

            if (!Directory.Exists(path) && !File.Exists(path))
            {
                throw new System.Exception("File "+path+"is not Exists!");
            }

            DirectoryInfo dir_inf = new DirectoryInfo(path);

            Dictionary<string, bool> TestResults = new Dictionary<string, bool>();

            //try
            //{
                foreach (DirectoryInfo dir in dir_inf.GetDirectories())
                {
                    Dictionary<string, bool> temp = ProcessDirRec(dir.FullName, server);

                    foreach (var node in temp)
                        TestResults.Add(node.Key, node.Value);
                }

                foreach (string file in Directory.GetFiles(path))
                {
                    if (Path.GetExtension(file) == ".zip")
                    {
                        string extractPath = file+"_temp.txt";                        
                        ZipFile.ExtractToDirectory(file, extractPath);
                        
                        Dictionary<string, bool> temp =  ProcessDirRec(extractPath, server);
                        foreach (var node in temp)
                            TestResults.Add(node.Key, node.Value);

                        DirectoryInfo di = new DirectoryInfo(extractPath);

                        if (di.Exists)
                            di.Delete(true);

                        continue;
                    }

                    if (Path.GetExtension(file) != ".txt") continue; //TODO: отмасштабировать

                    bool process_result = ProcessFile(file, server);
                    TestResults.Add(file, process_result);
                }
            //}
            //catch
            //{
            //    TestResults.Add(path, ProcessFile(path));
                //}

            return TestResults;
        }

        public void PrintTable()
        {
            if (!AllIsOk())
            {
                throw new System.Exception("RulesTable is not already exists!");
            }

            List<symbol> T = rules.T.ToList<symbol>();
            List<symbol> N = rules.N.ToList<symbol>();

            foreach (symbol a in T)
            {
                Console.Write("\t" + a);
            }
            Console.Write("\t|");
            foreach (symbol a in N)
            {
                Console.Write("\t" + a);
            }
            foreach (symbol a in T)
            {
                if (a != "$")
                    Console.Write("\t" + a);
            }
            Console.WriteLine();

            int i = 0;
            foreach (lr_table_string str in LRTable)
            {
                Console.Write(i);
                i++;
                foreach (symbol sym in T)
                {
                    if (str.Action.Keys.Contains(sym))
                    {
                        if (str.Action[sym].type != 'R')
                        {
                            Console.Write("\t" + str.Action[sym].type);
                        }
                        else
                        {
                            Console.Write("\t" + str.Action[sym].rule);
                        }
                    }
                    else
                    {
                        Console.Write("\t");
                    }
                }
                Console.Write("\t|");
                foreach (symbol a in N)
                {
                    if (str.Goto.Keys.Contains(a))
                    {
                        Console.Write("\t" + str.Goto[a]);
                    }
                    else
                    {
                        Console.Write("\t");
                    }
                }
                foreach (symbol a in T)
                {
                    if (a != "$")
                    {
                        if (str.Goto.Keys.Contains(a))
                        {
                            Console.Write("\t" + str.Goto[a]);
                        }
                        else
                        {
                            Console.Write("\t");
                        }
                    }
                }
                Console.WriteLine();
            }
        }

        bool AllIsOk()
        {
            if (rules == null || LRTable == null)
                return false;
            else
                return true;
        }
    }
}
