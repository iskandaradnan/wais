using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class DepartmentQRCodeReportController : Controller
    {
        // GET: BEMS/DepartmentQRCodeReport
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public ActionResult Index()
        {
            var userDetails = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetails.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetails);

            //ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
            //var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            ViewBag.FacilityId = userDetails.FacilityId;
            return View("DeptQRReport");
        }
    }
}