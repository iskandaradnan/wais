using System;
using System.Text;
using System.IO;
using System.Runtime.Serialization.Json;
namespace CP.Framework.Common.Audit
{
    public class Audit : IAudit
    {
        public bool Save(IAuditViewModel model)
        {
                var path = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, nameof(Audit), DateTime.UtcNow.ToShortDateString()+ ".txt");

                var ser = new DataContractJsonSerializer(model.GetType());
                using (var ms = new MemoryStream())
                {
                    ser.WriteObject(ms, model);
                    var jsonString = Encoding.UTF8.GetString(ms.ToArray());
                    ms.Close();
                    //var info = new UTF8Encoding(true).GetBytes(jsonString);
                    File.AppendAllText(path, Environment.NewLine + jsonString);
                }
            return true;
        }
    }
}
