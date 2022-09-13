using CP.Framework.Common.Audit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model;
using UETrack.Application.Web.Controllers;
using System.Configuration;
using System.IO;

namespace UETrack.Application.Web.Areas.Common.Controllers
{
    [WebAudit]
    [AuthenicationAction]
    //[AuthorizationAction]
    public class HomeController : BaseController
    {
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult DownloadManual(string FileName)
        {
            var pathLocation = ConfigurationManager.AppSettings["ManualDownloadPath"];
            if (!Directory.Exists(pathLocation))
                Directory.CreateDirectory(pathLocation);
            var finalpath = Path.Combine(pathLocation, FileName);
            var st = "application/pdf";
            var fileex = new FileInfo(finalpath);
            var c = '\\';
            var fileSplit = FileName.Split(c);
            if (fileSplit.Length > 1)
            {
                FileName = fileSplit[1];
            }
            if (FileName.Contains("apk"))
            {
                st = "application/apk";
            }
            if (fileex.Exists)
            {
                return File(finalpath, st, FileName);
            }
            else
            {
                return Content("Invalid File....", "text/plain");
            }

        }
    }
}