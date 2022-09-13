using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.Areas.VM.Controllers
{
    public class vmmonthcloseController : Controller
    {
        // GET: VM/vmmonthclose
        public ActionResult Index()
        {
            ViewBag.Id = 0;
            ViewBag.Mode = "ADD";
            ViewBag.CurrentYear = System.DateTime.Now.Year;
            ViewBag.CurrentMonth = System.DateTime.Now.Month;
            ViewBag.CurrentYearFinal = System.DateTime.Now.AddMonths(-1).Year;
            ViewBag.CurrentMonthFinal = System.DateTime.Now.AddMonths(-1).Month;

            //var today = DateTime.Today;

            //var MonthLastDay = new DateTime(today.Year, today.Month, 1).AddDays(-1).Day;
            //ViewBag.CutoffDate = new DateTime(today.Year, today.Month, MonthLastDay).Date.ToString("dd/MM/yyyy ");

            return View("Details");
        }

    }
}