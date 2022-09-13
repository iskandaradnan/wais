using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace UETrack.Application.Web.Helpers
{
    public class ReportBaseData
    {
        public string userName = ConfigurationManager.AppSettings["SsrsUserName"].ToString();
        public string passWord = ConfigurationManager.AppSettings["SsrsPassword"].ToString();
        public string domain = ConfigurationManager.AppSettings["SsrsDomain"].ToString();
        public string reportServerUrl = ConfigurationManager.AppSettings["SsrsReportServerUrl"].ToString();
        public string reportPath = ConfigurationManager.AppSettings["SsrsReportPath"].ToString();
        public string printPath = ConfigurationManager.AppSettings["SsrsPrintPath"].ToString();
    }
}