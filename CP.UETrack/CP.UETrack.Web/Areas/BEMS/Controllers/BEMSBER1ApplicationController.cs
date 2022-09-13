using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{

    public class BEMSBER1ApplicationController : Controller
    {
        // GET: BER/BER1Application
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public ActionResult List()
        {
            return View();
        }

        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.flag = "";
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "Add";
            return View("Detail");

            //return View(nameof(List));
        }
        public ActionResult filter(string flag)
        {
            ViewBag.flag = flag;
            return View(nameof(List));
        }
        public ActionResult Add()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "Add";
            return View("Detail");
        }

        public ActionResult Edit(int Id)
        {

            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "Edit";
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
            ViewBag.ActionType = "View";
            return View("Detail");
        }
    }
}