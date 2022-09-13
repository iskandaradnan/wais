using CP.Framework.Common.Audit;
using CP.UETrack.Application.Web.Filter;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UETrack.Application.Web.Controllers;

namespace UETrack.Application.Web.Areas.Reports.Controllers
{
    [AuthenicationAction]
    [WebAudit]
    [AuthorizationAction]
    public class ReportController : BaseController
    {
        // GET: Reports/Report
        public ActionResult Index()
        {
            return View();
        }
        
    }
}