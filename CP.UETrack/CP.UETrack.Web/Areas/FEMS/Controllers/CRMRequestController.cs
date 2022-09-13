using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    public class CRMRequestController : Controller
    {
        // GET: FEMS/CRMRequest


        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            //return View("List");
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Details");
        }
        public ActionResult Add()
        {
            ViewBag.Id = 0;
            //ViewBag.Mode = "ADD";
            ViewBag.ActionType = "Add";
            return View("Details");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.Id = id;
            //ViewBag.Mode = "EDIT";
            ViewBag.ActionType = "Edit";
            return View("Details");
        }
        public ActionResult View(int id)
        {
            ViewBag.Id = id;
            //ViewBag.Mode = "VIEW";
            ViewBag.ActionType = "View";
            return View("Details");
        }
    }
}