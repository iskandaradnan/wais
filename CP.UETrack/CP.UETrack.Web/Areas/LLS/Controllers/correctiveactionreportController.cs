using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.LLS.Controllers
{
    public class correctiveactionreportController : Controller
    {
        // GET: FEMS/correctiveactionreport
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index(int Id = 0)
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.LicenseId = Id;
            ViewBag.Id = 0;
            ViewBag.Mode = "ADD";
            return View("Detail");
        }
        public ActionResult Add()
        {

            ViewBag.Id = 0;
            ViewBag.Mode = "ADD";
            return View("Detail");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "EDIT";
            return View("Detail");
        }
        public ActionResult View(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "VIEW";
            return View("Detail");
        }
    }
}