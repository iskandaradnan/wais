using CP.UETrack.Application.Web.Filter;
using CP.Framework.Common.Audit;
using System.Web.Mvc;
using CP.UETrack.Model;
using CP.Framework.Common.StateManagement;

namespace UETrack.Application.Web.Areas.UM.Controllers
{
    [AuthenicationAction]
    [WebAudit]
    //[AuthorizationAction]
    public class UserRoleController : Controller
    {
        private string _ErrorMessage = string.Empty;
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            //return View("List");
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
    }
}