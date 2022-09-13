using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class TrackingTechnicianController : Controller
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        // GET: UM/TrackingTechnician
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            // Before it is individual we change to fems BD
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            return View("Detail");
        }
        public ActionResult Tracking()
        {
            return View("TrackingDetail");
        }
    }
}