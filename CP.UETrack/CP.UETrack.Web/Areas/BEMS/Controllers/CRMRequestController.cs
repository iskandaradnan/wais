using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class CRMRequestController : Controller
    {
        // GET: BEMS/CRMRequest



        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
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
        [HttpPost]
        public int Update_session(int id)
        {
            return 0;
        }
        
    }
}