using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class UserLocationController : Controller
    {
        // GET: BEMS/UserLocation
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            //  return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Add(int Id = 0)
        {
            ViewBag.UserAreaId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "Add";
            return View("Detail");
        }

        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "Edit";
            return View("Detail");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "View";
            return View("Detail");
        }
    }
}