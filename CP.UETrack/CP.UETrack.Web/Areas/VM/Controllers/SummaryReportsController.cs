using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.VM.Controllers
{
    public class SummaryReportsController : Controller
    {
        // GET: VM/SummaryReports

        // GET: BEMS/Customer
        public ActionResult Index()
        {
            return View("Detail");
        }
        public ActionResult View()
        {
            ViewBag.ActionType = nameof(View);
            return View("Detail");
        }
        //public ActionResult Add()
        //{

        //    ViewBag.CurrentID = 0;
        //    ViewBag.ActionType = nameof(Add);
        //    return View("Detail");
        //}

        //public ActionResult Edit(int Id)
        //{
        //    ViewBag.CurrentID = Id;
        //    ViewBag.ActionType = nameof(Edit);
        //    return View("Detail");
        //}

        //public ActionResult View(int Id)
        //{
        //    ViewBag.CurrentID = Id;
        //    ViewBag.ActionType = nameof(View);
        //    return View("Detail");
        //}
    }

}