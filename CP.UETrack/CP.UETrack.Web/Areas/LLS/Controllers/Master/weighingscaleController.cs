using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.LLS.Controllers
{
    public class weighingscaleController : Controller
    {
        // GET: MASTER/MASTERBlock
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("weighingscaleDetails");
        }
        public ActionResult Add()
        {

            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            return View("weighingscaleDetails");
        }

        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "EDIT";
            return View("weighingscaleDetails");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "VIEW";
            return View("weighingscaleDetails");
        }
    }
}