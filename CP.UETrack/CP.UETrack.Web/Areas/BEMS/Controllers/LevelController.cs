using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class LevelController : Controller
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        // GET: BEMS/Level
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            // return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            return View("Detail");
        }
        public ActionResult Add(int Id = 0)
        {
            ViewBag.BlockId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
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