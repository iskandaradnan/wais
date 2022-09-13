using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    public class LicenseandcertificatedetailsController : Controller
    {
        // GET: FEMS/Licenseandcertificatedetails
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index(int Id = 0)
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.LicenseId = Id;
            ViewBag.Id = 0;
            ViewBag.Mode = "ADD";
            return View("Details");
        }
        public ActionResult Add()
        {

            ViewBag.Id = 0;
            ViewBag.Mode = "ADD";
            return View("Details");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "EDIT";
            return View("Details");
        }
        public ActionResult View(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "VIEW";
            return View("Details");
        }
    }
}