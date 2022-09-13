using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    public class SummaryofFeeReportController : Controller
    {
        // GET: VM/SummaryofFeeReport
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.CurrentID = 0;
            ViewBag.Mode = "ADD";
            return View("Details");
            //  return View("List");
        }
        public ActionResult Add()
        {
            ViewBag.Mode = "ADD";
            ViewBag.PrimaryId = 0;
            return View("Details");
        }
        public ActionResult Reject(int id )
        {
            ViewBag.Mode = "Reject";
            ViewBag.PrimaryId = id;
            return View("Details");
        }
        public ActionResult Approve(int id)
        {
            ViewBag.Mode = "Approve";
            ViewBag.PrimaryId = id;
            return View("Details");
        }
        public ActionResult Verify(int id)
        {
            ViewBag.Mode = "Verify";
            ViewBag.PrimaryId = id;
            return View("Details");
        }
        public ActionResult edit(int id)
        {
            ViewBag.Mode = "EDIT";
            ViewBag.PrimaryId = id;
            return View("Details");
        }
        public ActionResult View(int id)
        {
            ViewBag.Mode = "View";
            ViewBag.PrimaryId = id;
            return View("Details");
        }
    }
}