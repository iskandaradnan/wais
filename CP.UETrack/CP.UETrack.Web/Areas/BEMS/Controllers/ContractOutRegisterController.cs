using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class OutSourcedServiceRegisterController : Controller
    {
        // GET: BEMS/ContractOutRegister
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index(int Id = 0)
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
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
        public ActionResult Edit( int id)
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