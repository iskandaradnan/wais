using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.QAP.Controllers
{
    public class QAPDashboardController : Controller
    {
        // GET: QAP/QAPDashboard
        public ActionResult Index()
        {
            return View("details");
        }
    }
}