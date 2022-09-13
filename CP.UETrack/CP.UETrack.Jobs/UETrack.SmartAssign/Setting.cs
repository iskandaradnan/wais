using System;
using System.Configuration;

namespace email
{
    internal static class Setting
    {

        internal static int Interval = Convert.ToInt32(ConfigurationManager.AppSettings["INTERVAL_SECS"]);
        internal static int Interval_Email = Convert.ToInt32(ConfigurationManager.AppSettings["INTERVAL_FOR_EMAIL_SECS"]);
        internal static int INTERVAL_FOR_NotAssign_EMAIL = Convert.ToInt32(ConfigurationManager.AppSettings["INTERVAL_FOR_NotAssignEMAIL_SECS"]);
        
    }
}
