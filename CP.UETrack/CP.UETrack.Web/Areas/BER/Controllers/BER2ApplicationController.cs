using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BER.Controllers
{
    public class BER2ApplicationController : Controller
    {
        // GET: BER/BER2Application
        // GET: BER/BER1Application
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            //return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Add()
        {
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
        public ActionResult Verify(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Verify);
            return View("Detail");
        }
        public ActionResult Approve(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Approve);
            return View("Detail");
        }
        public ActionResult Reject(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Reject);
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