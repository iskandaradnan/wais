using Newtonsoft.Json;
//using System.Web.Script.Serialization;

namespace UETrack.Application.Web.Helpers
{
    public class JSSerializerHelper
    {
        public static string Serialize(dynamic data)
        {
            //Commented the below serializer and using Newtonsoft due to serialization issue of Timespan properties
            //var jsonSerializer = new JavaScriptSerializer();
            //var serializedData = jsonSerializer.Serialize(data);

            var serializedData = JsonConvert.SerializeObject(data);            
            return serializedData;            
        }

        public static dynamic Deserialize<dynamic>(string data)
        {
            var serializedData = JsonConvert.DeserializeObject<dynamic>(data);
            return serializedData;
        }

    }

}