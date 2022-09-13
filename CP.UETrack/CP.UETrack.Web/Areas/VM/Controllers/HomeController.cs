using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.VM.Controllers
{
    public class HomeController : Controller
    {
        // GET: VM/Home
        public ActionResult Index()
        {
            return View();
        }
    }
}