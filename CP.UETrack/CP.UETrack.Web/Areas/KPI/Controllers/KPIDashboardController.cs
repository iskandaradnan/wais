using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.KPI.Controllers
{
    public class KPIDashboardController : Controller
    {
        // GET: KPI/KPIDashboard
        public ActionResult Index()
        {
            return View("Details");
        }
    }
}