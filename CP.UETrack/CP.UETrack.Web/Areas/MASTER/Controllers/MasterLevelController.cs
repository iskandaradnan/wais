using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;

using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.MASTER.Controllers
{
    [RoutePrefix("MasterLevel")]
    public class MasterLevelController : Controller
    {
        // GET: MASTER/MasterLevel
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
            // return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            return View("LevelDetail");
        }
        public ActionResult Add(int Id = 0)
        {
            ViewBag.BlockId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("LevelDetail");
        }

        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "Edit";
            return View("LevelDetail");
        }

        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "View";
            return View("LevelDetail");
        }
    }
}