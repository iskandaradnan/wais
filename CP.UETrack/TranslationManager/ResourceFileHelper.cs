using CP.UETrack.TranslationManager;
using System.Resources;

namespace CP.UETrack.TranslationManager
{
    public class ResourceFileHelper
    {
        /// <summary>
        /// Get the Error Message from Resource File
        /// </summary>
        /// <param name="messagekey"></param>
        /// <returns></returns>
        public static string GetErrorMessage(string messagekey)
        {
            var resxManager = new ResourceManager(typeof(ErrorMessages));
            
            var returnVal = resxManager.GetString(messagekey);
            return returnVal;

        }

        /// <summary>
        /// Get the Common Messages from Resource File
        /// </summary>
        /// <param name="messagekey"></param>
        /// <returns></returns>
        public static string GetCommonMessage(string messagekey)
        {
            var resxManager = new ResourceManager(typeof(CommonMessages));

            var returnVal = resxManager.GetString(messagekey);
            return returnVal;

        }

        public string GetErrorMessagesFromResource(string key)
        {
            ResourceManager resxManager = new ResourceManager(typeof(ErrorMessages));

            var returnVal = resxManager.GetString(key);
            return returnVal;
        }

    }

}