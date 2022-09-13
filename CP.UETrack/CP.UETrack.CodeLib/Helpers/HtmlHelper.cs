namespace CP.UETrack.CodeLib.Helpers
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Web;

    public static class HtmlHelper
    {
        readonly static string SVN_PROPERTY_REVISION =  "char *Revision      = \"";
        readonly static string SVN_PROPERTY_CUSTDATE =  "char *CustDateUTC   = \"";        
        readonly static string SVN_PROPERTY_DATE =      "char *Date          = \"";
        readonly static string SVN_PROPERTY_BRANCH =    "char *URL           = \"";

        public static string GetSvnInfo()
        {
            var svnInfo = "SVN no.:{0}; dt.: {1}";
            var revisionNo = "xyz";
            var date = "yy-MM-dd";
            try
            {
                var filePath = HttpContext.Current.Server.MapPath("/bin/SVNRevision.txt");
                if (File.Exists(filePath))
                {
                    var allLines = File.ReadLines(filePath);
                    revisionNo = FetchSvnProperty(allLines, SVN_PROPERTY_REVISION);
                    date = FetchSvnProperty(allLines, SVN_PROPERTY_DATE);
                }
            }
            finally
            {
                date = date.Replace("/", "-");
                svnInfo = string.Format(svnInfo, revisionNo, date);
            }

            return svnInfo;

        }

        static string FetchSvnProperty(IEnumerable<string> AllLines, string Key)
        {
            var value = AllLines.Where(d => d.StartsWith(Key, StringComparison.CurrentCulture));
            return value.FirstOrDefault().Replace(Key, string.Empty).Replace("\";", string.Empty);

        }

    }

}
