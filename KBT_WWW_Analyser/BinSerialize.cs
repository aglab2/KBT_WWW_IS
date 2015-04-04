using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;

namespace KBT_WWW_IS
{
    public class BinSerialize
    {
        public static void Write(object ser_object, string FileName)
        {
            Stream TestFileStream = File.Create(FileName);
            BinaryFormatter serializer = new BinaryFormatter();
            serializer.Serialize(TestFileStream, ser_object);
            TestFileStream.Close();
        }

        public static object Read(string FileName)
        {
            Stream TestFileStream = File.OpenRead(FileName);
            BinaryFormatter deserializer = new BinaryFormatter();
            object ret = deserializer.Deserialize(TestFileStream);
            TestFileStream.Close();
            return ret;
        }
    }
}
