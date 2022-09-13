using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.KPI.Controllers
{
    public class MonthlyServiceFeeController : Controller
    {
        // GET: KPI/MonthlyServiceFee

        public ActionResult Index()
        {
            return View("Details");
        }
        //public ActionResult List()
        //{
        //    return View();
        //}
        //public ActionResult Index()
        //{
        //    ViewBag.Id = 0;
        //    ViewBag.ActionType = nameof(Add);
        //    return View("Details");
        //    //return View(nameof(List));
        //}
        //public ActionResult Add()
        //{
        //    ViewBag.Id = 0;
        //    ViewBag.ActionType = nameof(Add);
        //    return View("Details");
        //}
        //public ActionResult Edit(int id)
        //{
        //    ViewBag.Id = id;
        //    ViewBag.ActionType = nameof(Edit);
        //    return View("Details");
        //}
        //public ActionResult View(int id)
        //{
        //    ViewBag.Id = id;
        //    ViewBag.ActionType = nameof(View);
        //    return View("Details");
        //}
    }
}