using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.VM.Controllers
{
    public class VMDashboardController : Controller
    {
        // GET: VM/VMDashboard
        public ActionResult Index()
        {
            return View("Details");
        }
    }
}