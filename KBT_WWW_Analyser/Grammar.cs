using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using System.Security.Permissions;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace KBT_WWW_IS
{
    [System.Serializable]
    public class symbol: System.Object
    {
        public string Name;
        public Collection<object> attr;

        public override bool Equals(System.Object obj)
        {
            if (obj == null) return false;
            
            symbol p = obj as symbol;
            if ((System.Object)p == null) return false;

            return (Name == p.Name);
        }

        public symbol(string str, object obj)
        {
            this.Name = str;
            attr = new Collection<object>();
            attr.Add(obj);
        }

        public symbol(char s, object obj)
        {
            this.Name = s.ToString();
            attr = new Collection<object>();
            attr.Add(obj);
        }

        public symbol(symbol s)
        {
            this.Name = s.Name;
        }

        public symbol(string name)
        {
            this.Name = name;
        }

        public symbol(char s)
        {
            this.Name = s.ToString();
        }

        public symbol()
        { }

        public static symbol_string operator +(symbol a, symbol b)
        {
            if (((object)a == null) || ((object)b == null)) return null;

            symbol_string ret = new symbol_string();
            ret.Add(a);
            ret.Add(b);

            return ret;
        }

        public static symbol_string operator +(symbol a, symbol_string b)
        {
            return new symbol_string(a) + b;
        }

        public static symbol_string operator +(symbol_string a, symbol b)
        {
            return a + new symbol_string(b);
        }

        public static bool operator ==(symbol a, symbol b)
        {
            if (System.Object.ReferenceEquals(a, b)) return true;
            if (((object)a == null) || ((object)b == null)) return false;

            return a.Name == b.Name;
        }

        public static bool operator ==(symbol a, string b)
        {
            if (((object)a == null) || ((object)b == null)) return false;

            return a.Name == b;
        }

        public static bool operator !=(symbol a, symbol b)
        {
            return !(a == b);
        }

        public static bool operator !=(symbol a, string b)
        {
            return !(a == b);
        }

        public override int GetHashCode()
        {
            return Name.GetHashCode();// ^ attr.GetHashCode();
        }

        public override string ToString()
        {
            return this.Name;
        }
        public static readonly symbol e = new symbol("");
    }  

    [System.Serializable]
    public class symbol_string: Collection<symbol>
    {
        public symbol_string() { }
        public symbol_string(string name)
        {
            foreach (char a in name)
            {
                this.Add(new symbol(a));
            }
        }

        public symbol_string(symbol sym)
        {
            this.Add(sym);
        }

        public symbol_string(IEnumerable<symbol> coll)
        {
            foreach (symbol a in coll)
            {
                this.Add(a);
            }
        }

        public override bool Equals(System.Object obj)
        {
            if (obj == null) return false;

            return this.SequenceEqual(obj as Collection<symbol>);
        }

        public static symbol_string operator +(symbol_string a, symbol_string b)
        {
            Collection<symbol> u = a as Collection<symbol>;
            Collection<symbol> v = b as Collection<symbol>;

            if (u == null && v == null) return null;
            if (u == null) return b;
            if (v == null) return a;

            IEnumerable<symbol> ll = u.Concat(v);
            symbol_string ret = new symbol_string(ll);
            return ret;
        }

        public static symbol_string operator +(symbol_string a, string b)
        {
            a.Add(new symbol(b));
            return a;
        }

        public static bool operator ==(symbol_string a, symbol_string b)
        {
            if (((object)a == null) || ((object)b == null)) return false;

            return a.SequenceEqual(b);
        }

        public static bool operator !=(symbol_string a, symbol_string b)
        {
            return !(a == b);
        }

        public static bool operator ==(symbol_string a, symbol b)
        {
            if (((object)a == null) || ((object)b == null)) return false;
            if (a.Count != 1) return false;

            return a[0] == b;
        }

        public static bool operator !=(symbol_string a, symbol b)
        {
            return !(a == b);
        }

        public static bool operator ==(symbol_string a, string b)
        {
            if (((object)a == null) || ((object)b == null)) return false;
            //if (a.Count != 1) return false;

            return a == new symbol_string(b);
        }

        public static bool operator !=(symbol_string a, string b)
        {
            return !(a == b);
        }
        
        public override int GetHashCode()
        {
            return this.ToString().GetHashCode();// ^ attr.GetHashCode();
        }
        
        public symbol_string Substring(int count)
        {
            IEnumerable<symbol> skipped = this.Skip(count);
            symbol_string ret = new symbol_string(skipped);
            return ret;
        }

        public override string ToString()
        {
            string l = "";
            foreach (symbol a in this)
            {
                l += a.Name;
            }
            return l;
        }
    }

    [System.Serializable]
    public class rule_table : Dictionary<symbol, Collection< rule_l >>
    {
        private HashSet<symbol> _N;
        public HashSet<symbol> N
        {
            get { return _N; }
        }
        private HashSet<symbol> _T;
        public HashSet<symbol> T
        {
            get { return _T; }
        }

        public string CommentLineStartSymbol;
        
        public symbol S;
        public symbol lrS;
        public symbol lrD;

        public rule_table()
        {
            _N = new HashSet<symbol>();
            _T = new HashSet<symbol>();
            CommentLineStartSymbol = "";
            S = null;
            lrD = null;
            lrS = null;
        }

        public rule Add_Rule(symbol A, symbol_string rt, MethodInfo attrule, object inst)
        {
            if (!this.Keys.Contains(A)) this.Add(A, new Collection<rule_l>());
            rule_l rl = new rule_l(rt, attrule, inst);
            this[A].Add(rl);
            return new rule(A, rl);
        }

        protected rule_table(SerializationInfo si, StreamingContext context)
            : base(si, context)
        {
            this._N = (HashSet<symbol>)si.GetValue("N", typeof(HashSet<symbol>));
            this._T = (HashSet<symbol>)si.GetValue("T", typeof(HashSet<symbol>));

            this.S = (symbol)si.GetValue("S", typeof(symbol));
            this.lrS = (symbol)si.GetValue("lrS", typeof(symbol));
            this.lrD = (symbol)si.GetValue("lrD", typeof(symbol));

            this.CommentLineStartSymbol = si.GetString("CommentLineStartSymbol");
        }

        [SecurityPermissionAttribute(SecurityAction.Demand, SerializationFormatter = true)]
        public override void GetObjectData(SerializationInfo si, StreamingContext context)
        {
            base.GetObjectData(si, context);

            si.AddValue("N", this._N);
            si.AddValue("T", this._T);
            si.AddValue("S", this.S);
            si.AddValue("lrS", this.lrS);
            si.AddValue("lrD", this.lrD);

            si.AddValue("CommentLineStartSymbol", this.CommentLineStartSymbol);
        }
    }

    [System.Serializable]
    public class rule_l
    {
        public symbol_string str;
        public MethodInfo attrrules;
        public object instance;

        public rule_l(symbol_string strrule, MethodInfo a, object inst)
        {
            str = strrule;
            attrrules = a;
            instance = inst;
        }

        public rule_l(symbol_string S)
        {
            str = S;
        }

        public override string ToString()
        {
            return str.ToString();
        }
    }

    [System.Serializable]
    public class rule //Only left part (rule_l = null) is allowed to be used as rule templaye
    {
        public symbol A;
        public rule_l rule_l;

        public rule(symbol A)
        {
            this.A = A;
        }

        public rule(symbol A, rule_l rl)
        {
            this.A = A;
            this.rule_l = rl;
        }

        public override bool Equals(object obj)
        {
            rule r = obj as rule;
            if (r == null) return false;

            if (this.A != r.A) return false;
            return this.rule_l.str == r.rule_l.str;
        }

        public override int GetHashCode()
        {
            return this.A.GetHashCode() ^ this.rule_l.str.GetHashCode();
        }
        
        public static bool operator==(rule r, rule l)
        {
            if ((object)r == null || (object)l == null) return false;
            if (r.A != l.A) return false;
            return r.rule_l.str != l.rule_l.str;
        }
        
        public static bool operator !=(rule r, rule l)
        {
            return !(r == l);
        }

        public override string ToString()
        {
            if (this.rule_l == null)
            {
                return A.ToString();
            }
            else
            {
                return this.A.ToString() + "->" + this.rule_l.ToString();
            }
        }
    }
}
