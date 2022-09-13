using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.EOD.Controllers
{
    public class HomeController : Controller
    {
        // GET: EOD/Home
        public ActionResult Index()
        {
            return View();
        }

        //public ActionResult EodDashboard()
        //{
        //    return View(nameof(Index));
        //}
    }
}