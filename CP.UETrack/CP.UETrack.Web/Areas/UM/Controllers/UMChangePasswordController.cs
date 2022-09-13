
using CP.UETrack.Application.Web.Filter;
using CP.Framework.Common.Audit;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.UM.Controllers
{
    //[AuthenicationAction]
    //[WebAudit]
    //[AuthorizationAction]
    [AllowAnonymous]
    public class UMChangePasswordController : Controller
    {
        public ActionResult Index()
        {
            //var userName = string.Empty;
            //var password = string.Empty;

            //userName = System.Web.HttpUtility.UrlEncode(Request.QueryString["se"]);
            //password = System.Web.HttpUtility.UrlEncode(Request.QueryString["ps"]);

            //ViewBag.Username = userName;
            //ViewBag.Password = password;

            ViewBag.ActionType = "Add";
            return View("Detail");
        }
    }
}