using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class External_loanerequipmentController : Controller
    {
        // GET: BEMS/loanerequipment
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            // return View();
            ViewBag.Id = 0;
            ViewBag.Mode = "Add";
            return View("~/Areas/BEMS/Views/loanerequipment/Details.cshtml");
        }
        public ActionResult Add()
        {

            ViewBag.Id = 0;
            ViewBag.Mode = "Add";
            // return View();
            return View("~/Areas/BEMS/Views/loanerequipment/Details.cshtml");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "Edit";
            // return View();
            return View("~/Areas/BEMS/Views/loanerequipment/Details.cshtml");
        }
        public ActionResult View(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "View";
            // return View();
            return View("~/Areas/BEMS/Views/loanerequipment/Details.cshtml");
        }
    }
}