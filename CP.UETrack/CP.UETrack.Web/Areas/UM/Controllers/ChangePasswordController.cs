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
    public class ChangePasswordController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.ActionType = "Add";
            return View("Detail");
        }
    }
}