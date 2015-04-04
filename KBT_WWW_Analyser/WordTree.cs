using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KBT_WWW_IS
{
    [System.Serializable]
    public class WordTree
    {
        public Node start;
        public void PrintPretty(string indent, bool last)
        {
            start.PrintPretty(indent, last);
        }
        public List<symbol> word()
        {
            return start.word();
        }

        public Collection<object> attrib()
        {
            return start.attrib();
        }
    }

    [System.Serializable]
    public class Node
    {
        public void PrintPretty(string indent, bool last)
        {
            Console.Write(indent);
            if (last)
            {
                Console.Write("\\-");
                indent += "  ";
            }
            else
            {
                Console.Write("|-");
                indent += "| ";
            }
            Console.Write(Name.A);
            Console.Write(" (");
            
            if (Name.A.attr != null){
                if (Name.A.attr[0] != null && (string)Name.A.attr[0] != "\n" ){
                    Console.Write(Name.A.attr[0]);
                }
            }
            
            Console.Write(")");
            Console.WriteLine();

            if (link != null)
            {
                for (int i = 0; i < link.Count; i++)
                    link[i].PrintPretty(indent, i == link.Count - 1);
            }
        }

        public Node() { }

        public Node(rule A)
        {
            this.Name = A;
            this.link = null;
        }

        public Node(symbol A) //Node Template
        {
            this.Name = new rule(A);
            this.link = null;
        }

        public List<symbol> word()
        {
            if (link == null)
            {
                List<symbol> ret = new List<symbol>();
                ret.Add(Name.A);
                return ret;
            }
            else
            {
                List<symbol> ret = new List<symbol>();
                foreach (Node nl in link)
                {
                    ret = ret.Concat(nl.word()).ToList();
                }
                return ret;
            }
        }

        public Collection<object> attrib()
        {
            if (link == null)
            {
                return Name.A.attr;
            }
            else
            {
                Collection<object> args = new Collection<object>();
                foreach (Node nl in link)
                {
                    args.Add(nl.attrib());
                }
                try
                {
                    Collection<object> ret = (Collection<object>)Name.rule_l.attrrules.Invoke(Name.rule_l.instance, args.ToArray<object>());
                    Exception err = null;
                    try
                    {
                        if (ret.Count == 0) throw new Exception("");
                        err = (Exception)ret[0];
                    }
                    catch (Exception)
                    {
                        Console.Error.WriteLine("Fuck you, bad guy! Use 0 for exceptions!!!!!");
                        Console.Error.WriteLine("Function " + Name.rule_l.attrrules.Name);
                        Console.Error.WriteLine("BTW, it is " + ret[0]);
                    }
                    if (err != null) throw err;
                    return ret;
                }
                catch (Exception e)
                {
                    Console.Error.WriteLine(e.ToString());
                    throw new Exception("Bad things happened master. Function " + Name.rule_l.attrrules.Name);
                }
            }
        }
        
        public rule Name;
        public NodeLink link;
        public Collection<object> a;
    }

    [System.Serializable]
    public class NodeLink: Collection<Node> { }
}
