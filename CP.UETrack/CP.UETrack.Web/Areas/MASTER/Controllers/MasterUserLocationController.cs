using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System.Web.Http;


namespace UETrack.Application.Web.Areas.MASTER.Controllers
{
    [RoutePrefix("MasterUserLocation")]
    public class MasterUserLocationController : Controller
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        // GET: Master/UserLocation
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            //  return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("MasterUserLocationDetail");
        }
        public ActionResult Add(int Id = 0)
        {
            ViewBag.UserAreaId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "Add";
            return View("MasterUserLocationDetail");
        }

        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "Edit";
            return View("MasterUserLocationDetail");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "View";
            return View("MasterUserLocationDetail");
        }
    }
}