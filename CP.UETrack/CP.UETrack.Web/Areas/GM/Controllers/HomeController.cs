using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.GM.Controllers
{
    public class HomeController : Controller
    {
        // GET: GM/Home
        public ActionResult Index()
        {
            return View();
        }
    }
}