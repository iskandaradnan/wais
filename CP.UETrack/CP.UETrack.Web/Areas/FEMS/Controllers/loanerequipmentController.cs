using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    public class loanerequipmentController : Controller
    {
        // GET: FEMS/loanerequipment
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index(int Id = 0)
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.TestingAndCommissioningId = Id;
            ViewBag.Id = 0;
            ViewBag.Mode = "Add";
            return View("Details");
            //return View("List");
        }
        public ActionResult Get(int Id = 0)
        {
            ViewBag.AssetId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ARActionType = nameof(Add);
            return View("Details");
        }
        public ActionResult Add()
        {

            ViewBag.Id = 0;
            ViewBag.Mode = "Add";
            return View("Details");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "Edit";
            return View("Details");
        }
        public ActionResult View(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "View";
            return View("Details");
        }
    }
}