using CP.UETrack.Application.Web.Filter;
using CP.Framework.Common.Audit;
using System.Web.Mvc;
using CP.UETrack.Model;
using CP.Framework.Common.StateManagement;

namespace UETrack.Application.Web.Areas.UM.Controllers
{

   

    
    [AllowAnonymous]
    public class ForgotPasswordController : Controller
    {
        //readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {
            //var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            //userDetail.UserDB = 0;
            //_sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.ActionType = "Add";
            return View("Detail");
        }
    }
}