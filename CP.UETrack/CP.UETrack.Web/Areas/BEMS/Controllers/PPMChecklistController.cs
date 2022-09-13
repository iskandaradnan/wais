using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class PPMChecklistController : Controller
    {
        // GET: BEMS/PPMChecklist
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Add()
        {

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

        [HttpPost]
        public ActionResult ChangeDB(int ID)
        {
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(ChangeDB);
            JsonResult res = new JsonResult();
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = ID;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            return res;
        }
        public JsonResult DemoCall(int number)
        {
            return Json($"{number}", JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult AddToCart(string id)
        {
            string newId = id;
            return Json(newId, JsonRequestBehavior.AllowGet);
        }
    }
}