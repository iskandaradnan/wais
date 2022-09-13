using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.Reports.Controllers
{
    public class CARSummaryReportController : Controller
    {
        // GET: Reports/CARSummaryReport
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public ActionResult Index()
        {
            /// Added for bems DB -- before it is individual
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            ///
            return View("Detail");
        }
    }
}