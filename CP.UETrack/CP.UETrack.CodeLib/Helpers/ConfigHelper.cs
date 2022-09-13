namespace CP.UETrack.CodeLib.Helpers
{
    using System.Configuration;

    public static class ConfigHelper
    {

        public static string GetConfig(string configKey)
        {
            var configValue = string.Empty;

            try
            {
                configValue = ConfigurationManager.AppSettings[@configKey].ToString();
            }
            catch
            {
                //to log exception
            }

            return configValue;

        }

    }
}
