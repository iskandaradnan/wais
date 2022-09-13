using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.QAP.Controllers
{
    public class QAPIndicatorMasterController : Controller
    {
        // GET: QAP/QAPIndicatorMaster

        //public ActionResult Index()
        //{
        //    return View("Details");
        //}
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            /// Added for bems DB -- before it is individual
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.Id = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Details");
            //return View(nameof(List));
        }
        public ActionResult Add()
        {
            ViewBag.Id = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Details");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.Id = id;
            ViewBag.ActionType = nameof(Edit);
            return View("Details");
        }
        public ActionResult View(int id)
        {
            ViewBag.Id = id;
            ViewBag.ActionType = nameof(View);
            return View("Details");
        }
    }
}