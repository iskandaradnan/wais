using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    public class MonthlyStockRegisterController : Controller
    {
        // GET: FEMS/MonthlyStockRegister
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            return View("Details");
        }
    }
}