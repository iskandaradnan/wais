using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class arpController : Controller
    {
       
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        private ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "Add";
            return View("ArpDetail");
        }
        public ActionResult Add()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "Add";
            return View("ArpDetail");
        }

        public ActionResult Edit(int Id)
        {

            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "Edit";
            return View("ArpDetail");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "View";
            return View("ArpDetail");
        }
    }
}