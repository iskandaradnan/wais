using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.FER.Controllers
{
    public class BER2ApplicationController : Controller
    {
        // GET: BER/BER2Application
        // GET: BER/BER1Application
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.flag = "";
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