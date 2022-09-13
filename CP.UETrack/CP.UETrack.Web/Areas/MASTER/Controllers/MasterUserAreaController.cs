using System.Runtime.InteropServices;
using System.Web.Http;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.MASTER.Controllers
{
   [RoutePrefix("Masteruserarea")]
    public class MasterUserAreaController : Controller
    {
        // GET: BEMS/UserArea
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
            //return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("MasterUserAreaDetail");
        }
        public ActionResult Add(int Id = 0)
        {
            ViewBag.LevelId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("MasterUserAreaDetail");
        }

        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Edit);
            return View("MasterUserAreaDetail");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(View);
            return View("MasterUserAreaDetail");
        }
    }
}