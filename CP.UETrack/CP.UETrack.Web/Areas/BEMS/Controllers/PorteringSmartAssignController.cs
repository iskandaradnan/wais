using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.Bems.Controllers
{
    public class PorteringSmartAssignController : Controller
    {
        // GET: SmartAssign/PorteringSmartAssign
       
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            // return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            return View("Detail");
        }
    }
}