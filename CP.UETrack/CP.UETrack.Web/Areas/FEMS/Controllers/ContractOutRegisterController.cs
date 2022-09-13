using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    public class OutSourcedServiceRegisterController : Controller
    {
        // GET: FEMS/ContractOutRegister
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index(int Id = 0)
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.ContractId = Id;
            ViewBag.ActionType = "ADD";
            ViewBag.CurrentID = 0;
            return View("Details");
            //return View("List");
        }
        public ActionResult Add()
        {
            ViewBag.ActionType = "ADD";
            ViewBag.CurrentID = 0;
            return View("Details");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.ActionType = "EDIT";
            ViewBag.CurrentID = id;
            return View("Details");
        }
        public ActionResult View(int id)
        {
            ViewBag.ActionType = "VIEW";
            ViewBag.CurrentID = id;
            return View("Details");
        }
    }
}