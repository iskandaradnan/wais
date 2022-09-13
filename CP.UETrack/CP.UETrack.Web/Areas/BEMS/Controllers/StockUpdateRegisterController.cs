using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class StockUpdateRegisterController : Controller
    {
        // GET: BEMS/StockUpdateRegister
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.Id = 0;
            ViewBag.Mode = "ADD";
            return View("Details");
            // return View();
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