using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.UETrack.Model;
using CP.Framework.Common.StateManagement;

namespace UETrack.Application.Web.Areas.UM.Controllers
{
    public class SmartAssignController : Controller
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        // GET: UM/SmartAssign
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            // Before it is individual we change to bems BD
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            //return View("List");

            return View("Detail");
        }
    }
}