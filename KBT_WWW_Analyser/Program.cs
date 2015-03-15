//#define FAST

using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.IO;

namespace KBT_WWW_IS
{
    class Program
    {
        static void Main(string[] args)
        {
            string server = null;
            using (StreamReader CFGFile = new StreamReader("config.cfg"))
            {
                server = CFGFile.ReadLine();
            }
            Console.WriteLine("-- Enter the Analyser name in format {G1 | G1.1 | G1.2 | G2 | G3}.{xml | bin}");
            Console.WriteLine("-- use extension .xml to build a new, .bin to load existing Analyser");

            string FName = Console.ReadLine();
            FName = Path.GetFileNameWithoutExtension(FName) +"\\"+ FName;

            GAnalyser GAnalyser = null;

            string s = Path.GetExtension(FName);
            try
            {
                if (s == ".bin")
                {
                    Console.WriteLine("-- Try to load existing analyser " + FName + "...\t");
                    GAnalyser = (GAnalyser)BinSerialize.Read(FName);
                    Console.WriteLine("-- Ok!");
                }
                else
                    if (s == ".xml")
                    {
                        Console.WriteLine("-- Building Analyser using " + FName + "...\t");
                        GAnalyser = new GAnalyser(FName);
                        string s1 = Path.GetDirectoryName(FName) + "\\" + Path.GetFileNameWithoutExtension(FName)+".bin";
                        
                        BinSerialize.Write(GAnalyser, s1);
                        Console.WriteLine("-- Ok!");
                    }
                    else
                        Console.WriteLine("-- Bad extension! "+s);

                Console.WriteLine("-- Great! Enter the name of the directory or the file to process:\tMEGATEST");

#if (FAST)
                string dir_to_process = "MEGATEST";// Console.ReadLine();
#else
                string dir_to_process = Console.ReadLine();
#endif

                Dictionary<string, bool> Results = GAnalyser.ProcessDirRec(dir_to_process, server);

                Console.WriteLine("\n\n-- TEST RESULTS");
                foreach (var key in Results.Keys)
                    if (Results[key] == false) // only bad reports
                        Console.WriteLine("-- " + key + ":" + Results[key]);
            }
            catch (Exception E)
            {
                Console.WriteLine(E.Message);
            }

#if (!FAST)
            //Console.ReadKey();
#endif
        }
    }
}
