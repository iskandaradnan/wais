using CP.Framework.Common.Audit;
using CP.UETrack.Application.Web.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    [AuthenicationAction]
    [WebAudit]
    //[AuthorizationAction]
    public class TestingAndCommissioningController : Controller
    {
        // GET: FEMS/TestingAndCommissioning
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            ViewBag.UserRoleId = userDetail.UserRoleId;
            ViewBag.ModuleId = userDetail.ModuleId;
            return View("Detail");
            // return View("List");
        }
        public ActionResult Add()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Edit);
            return View("Detail");
        }
        public ActionResult Verify(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Verify);
            return View("Detail");
        }
        public ActionResult Approve(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Approve);
            return View("Detail");
        }
        public ActionResult Reject(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Reject);
            return View("Detail");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(View);
            return View("Detail");
        }
    }
}