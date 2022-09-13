
using System;
using System.Web.Mvc;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;

namespace ASIS.Application.Web.Helper
{

    public static class HtmlHelpers
    {

        
        public static string SVNRevision()
        {
            var svnRev = string.Empty;
            try
            {

                IEnumerable<string> allLines;
                var filePath = HttpContext.Current.Server.MapPath("/bin/SVNRevision.txt");
                if (File.Exists(filePath))
                {
                    allLines = File.ReadLines(filePath);
                    svnRev = " SVN Revision no " + FetchSvnProperty(allLines, "char *Revision      = \"") + " dated " + FetchSvnProperty(allLines, "char *CustDateUTC   = \"");
                }

            }
            catch(Exception)
            {
                throw;
            }
            return svnRev;
        }
        public static string FetchSvnProperty(IEnumerable<string> AllLines, string Key)
        {
            var value = AllLines.Where(d => d.StartsWith(Key, StringComparison.CurrentCulture));

            return value.FirstOrDefault().Replace(Key,string.Empty).Replace("\";","");
        }

    }


}
