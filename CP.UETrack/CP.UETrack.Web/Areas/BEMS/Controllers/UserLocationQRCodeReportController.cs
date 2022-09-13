using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class UserLocationQRCodeReportController : Controller
    {
        // GET: BEMS/UserLocationQRCodeReport
        public ActionResult Index()
        {
            ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
            var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            ViewBag.FacilityId = userDetails.FacilityId;
            return View("UserLocQRReport");
        }
    }
}