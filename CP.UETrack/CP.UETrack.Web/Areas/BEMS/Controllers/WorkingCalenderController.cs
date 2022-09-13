using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class workingcalendarController : Controller
    {
        // GET: BEMS/UserLocation
        //public ActionResult List()
        //{
        //    ViewBag.CurrentID = 0;
        //    ViewBag.ActionType = "ADD";
        //    return View("Detail");
        //}
        public ActionResult Index()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "Add";
            return View("Detail");
        }
        //public ActionResult Add()
        //{

        //    ViewBag.CurrentID = 0;
        //    ViewBag.ActionType = "ADD";
        //    return View("Detail");
        //}

        //public ActionResult Edit(int Id)
        //{
        //    ViewBag.CurrentID = Id;
        //    ViewBag.ActionType = "EDIT";
        //    return View("Detail");
        //}

        //public ActionResult View(int Id)
        //{
        //    ViewBag.CurrentID = Id;
        //    ViewBag.ActionType = "VIEW";
        //    return View("Detail");
        //}
    }
}