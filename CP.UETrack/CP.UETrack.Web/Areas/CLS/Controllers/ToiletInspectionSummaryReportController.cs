using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.CLS.Controllers
{
    public class ToiletInspectionSummaryReportController : Controller
    {
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }

        public ActionResult Add()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            return View("Detail");
        }
    }
}