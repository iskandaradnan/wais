using System;
using System.Configuration;

namespace email
{
    internal static class Setting
    {

        internal static int Interval_Email = Convert.ToInt32(ConfigurationManager.AppSettings["INTERVAL_SECS"]);
        internal static int Interval_Scheduler = Convert.ToInt32(ConfigurationManager.AppSettings["INTERVAL_FOR_EMAIL_SECS"]);
    }
}
