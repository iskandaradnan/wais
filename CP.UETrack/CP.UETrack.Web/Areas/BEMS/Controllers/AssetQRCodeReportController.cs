using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UETrack.Application.Web.Controllers;


namespace UETrack.Application.Web.Areas.BEMS.Controllers
{    
    public class AssetQRCodeReportController : Controller
    {
        // GET: BEMS/AssetQRCodeReport
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult index()
        {
            var userDetails = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetails.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetails);

            //ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
            //var userDetails = (UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel));
            ViewBag.FacilityId = userDetails.FacilityId;
            return View("AssetQRReport");
        }
        
    }
}
