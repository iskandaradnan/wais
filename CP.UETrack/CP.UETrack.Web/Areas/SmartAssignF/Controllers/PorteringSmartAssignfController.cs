using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.SmartAssignF.Controllers
{
    public class PorteringSmartAssignfController : Controller
    {
        // GET: SmartAssign/PorteringSmartAssign
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            //return View("List");

            return View("Detail");
        }
    }
}