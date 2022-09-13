using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.LLS.Controllers
{
    public class PerformanceMonitoringReportController : Controller
    {
        // GET: Reports/PerformanceMonitoringReport
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            ///
            return View("Detail");
        }
    }
}