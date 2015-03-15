using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;

[System.Serializable]
public class Attribute
{
    public Collection<object> Start(Collection<object> w, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> S1(Collection<object> n, Collection<object> d, Collection<object> p, Collection<object> W, Collection<object> nl, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> S2(Collection<object> n, Collection<object> q, Collection<object> d, Collection<object> p, Collection<object> W, Collection<object> nl, Collection<object> S)
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }

    public Collection<object> S0()
    {
        Collection<object> ret = new Collection<object>();
        return ret;
    }


    public Collection<object> w(Collection<object> W, Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add((string)W[0] + (string)s[0]);
        return ret;
    }

    public Collection<object> w1(Collection<object> s)
    {
        Collection<object> ret = new Collection<object>();
        ret.Add((string)s[0]);
        return ret;
    }

}
