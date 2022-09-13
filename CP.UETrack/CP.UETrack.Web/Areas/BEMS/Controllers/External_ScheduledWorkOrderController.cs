using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class External_ScheduledWorkOrderController : Controller
    {
        // GET: BEMS/PPMRegister
        public ActionResult List()
        {
            // return View();
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("~/Areas/BEMS/Views/ScheduledWorkOrder/Detail.cshtml");
        }
        public ActionResult Index()
        {
            // return View();
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("~/Areas/BEMS/Views/ScheduledWorkOrder/Detail.cshtml");
        }
        public ActionResult Add()
        {

            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            // return View();
            return View("~/Areas/BEMS/Views/ScheduledWorkOrder/Detail.cshtml");
        }

        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "EDIT";
            // return View();
            return View("~/Areas/BEMS/Views/ScheduledWorkOrder/Detail.cshtml");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "VIEW";
            // return View();
            return View("~/Areas/BEMS/Views/ScheduledWorkOrder/Detail.cshtml");
        }
    }
}