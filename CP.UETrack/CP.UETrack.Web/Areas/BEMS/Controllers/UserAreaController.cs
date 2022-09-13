using System.Runtime.InteropServices;
using System.Web.Http;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    [RoutePrefix("userareamaster")]
    public class UserAreaController : Controller
    {
        // GET: BEMS/UserArea
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
        public ActionResult Add(int Id = 0)
        {
            ViewBag.LevelId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }

        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Edit);
            return View("Detail");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(View);
            return View("Detail");
        }
    }
}