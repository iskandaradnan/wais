using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class MonthlyStockRegisterController : Controller
    {
        // GET: BEMS/MonthlyStockRegister
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
        //    return View(nameof(List));
        //}
        //public ActionResult Add()
        //{
        //    ViewBag.Id = 0;
        //    ViewBag.ActionType = "ADD";
        //    return View("Details");
        //}
        //public ActionResult Edit(int id)
        //{
        //    ViewBag.Id = id;
        //    ViewBag.ActionType = "EDIT";
        //    return View("Details");
        //}
        //public ActionResult View(int id)
        //{
        //    ViewBag.Id = id;
        //    ViewBag.ActionType = "VIEW";
        //    return View("Details");
        //}

    }
}