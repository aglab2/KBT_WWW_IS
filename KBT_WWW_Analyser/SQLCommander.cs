using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Collections.ObjectModel;

namespace KBT_WWW_IS
{
    class SQLCommander
    {
        SqlConnection conn;
        public SQLCommander(string connectionString)
        {
            //conn = new SqlConnection(connectionString);
            //conn.Open();
        }

        [SqlProcedure()]
        public void Execute(string name, Collection<Tuple<string, string>> param)
        {
            //SqlCommand cmd = new SqlCommand(name, conn);

            Console.Write("exec " + name);

            //cmd.CommandType = CommandType.StoredProcedure;

            bool fist = true;

            Collection<int> play = new Collection<int>();
           
            foreach (var i in param)
            {
                //cmd.Parameters.Add(new SqlParameter(i.Item1, i.Item2));
                if (fist)
                {
                    fist = false;
                    Console.Write(" " + i.Item1 + "='" + i.Item2.Replace('\'', '`').Trim() + "'");
                }
                else
                {
                    Console.Write("," + i.Item1 + "='" + i.Item2.Replace('\'', '`').Trim() + "'");
                }
            }
            
            Console.WriteLine();
            
            try
            {
                //cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }
    }
}
