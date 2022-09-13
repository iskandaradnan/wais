using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.Reports.Controllers
{
    public class Ber1PrintReportController : Controller
    {
        // GET: Reports/BER1PrintReport
        public ActionResult Index()
        {
            return View("Detail");
        }
    }
}