using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class BEMSBERDashboardController : Controller
    {
        // GET: BER/BERDashboard
        public ActionResult Index()
        {
            return View("Dashboard");
        }
    }
}