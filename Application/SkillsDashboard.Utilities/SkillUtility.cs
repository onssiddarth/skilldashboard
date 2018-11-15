using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Web;

namespace SkillsDashboard.Utilities
{
    /// <summary>
    /// This class will conatin all the generic methods which will be used throughout the application
    /// </summary>
    public class SkillUtility
    {
        /// <summary>
        /// This method is used to create a clone of an object
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="argInput"></param>
        /// <returns></returns>
        public static T DeepClone<T> (T argInput)
        {
            using (var l_MemoryStream = new MemoryStream())
            {
                var l_formatter = new BinaryFormatter();
                l_formatter.Serialize(l_MemoryStream, argInput);
                l_MemoryStream.Position = 0;

                return (T)l_formatter.Deserialize(l_MemoryStream);
            }
        }
    }
}