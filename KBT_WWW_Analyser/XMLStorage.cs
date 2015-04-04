using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Xsl;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Security.Permissions;
using System.Reflection;

namespace KBT_WWW_IS
{
    [System.Serializable]
    public class XMLStorage 
    {
        static public string MakePathName(string path, string extension)
        {
            return Path.GetDirectoryName(path) + "\\" + Path.GetFileNameWithoutExtension(path) + extension;
        }

        static public rule_table ImportXMLGrammar(string FileName)
        {
            if (!File.Exists(FileName)) return null;

            string path_in = MakePathName(FileName, ".cs");
            if (!File.Exists(path_in)) return null;

            string path_dll = MakePathName(FileName, ".dll");
            /*
            try
            {
                var proc = Process.Start("compile\\csc.exe", "/target:library /out:" + path_dll + " " + path_in);
                proc.WaitForExit();
            }
            catch (Exception E)
            {
                throw new Exception("Program components not found!\n" + E.Message);
            }
            */

            if (!CSCompiler.CompileCSharpCode(path_in, path_dll))
            {
                Console.WriteLine("Can't compile your shit. See ya!");
                Environment.Exit(1);
            }

            Assembly assembly = Assembly.LoadFrom(path_dll);
            Type type = assembly.GetType("Attribute");
            object instance = Activator.CreateInstance(type);

            XDocument doc = XDocument.Load(FileName);

            rule_table grammar = new rule_table();

            symbol left_rule_part = new symbol();
            symbol_string right_rule_part = new symbol_string();
            
            var ns = doc.Root.Name.Namespace;

            XElement xgrammar = doc.Element(ns + "grammar");

            if (xgrammar.Element(ns + "CommentLineStartSymbol") != null)
                grammar.CommentLineStartSymbol = xgrammar.Element(ns + "CommentLineStartSymbol").Value;

            grammar.S = new symbol(xgrammar.Element(ns + "SS").Value);

            foreach (var NS in xgrammar.Elements(ns + "NS"))
                grammar.N.Add(new symbol(NS.Value));

            foreach (var TS in xgrammar.Elements(ns + "TS"))
                grammar.T.Add(new symbol(TS.Value));

            foreach (var xrule in xgrammar.Elements(ns + "PR"))
            {
                string name = xrule.Attribute("attr").Value;

                left_rule_part = new symbol();
                right_rule_part = new symbol_string();

                foreach (var xrleft in xrule.Elements(ns + "left"))
                    foreach (var xrleftl in xrleft.Elements(ns + "PRS"))
                        if (left_rule_part.Name != "")
                        {
                            symbol item = new symbol(xrleftl.Value);
                            if (!grammar.N.Contains(item))
                                throw new Exception("\"" + xrleft.Value + "\" no such non terminal symbol in lib\n");

                            left_rule_part = item;
                        }
                        else return null;

                foreach (var xrright in xrule.Elements(ns + "right"))
                    foreach (var xrrightl in xrright.Elements(ns + "PRS"))
                    {
                        symbol item = new symbol(xrrightl.Value);
                        if (!grammar.N.Contains(item) && !grammar.T.Contains(item))
                            throw new Exception("\"" + xrrightl.Value + "\" no such symbol in lib\n");

                        right_rule_part += xrrightl.Value;
                    }

                grammar.Add_Rule(left_rule_part, right_rule_part, type.GetMethod(name), instance);
            }
            return grammar;
        }
    }
}