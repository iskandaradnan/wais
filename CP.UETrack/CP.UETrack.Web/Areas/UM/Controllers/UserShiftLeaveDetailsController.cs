using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.UETrack.Model;
using CP.Framework.Common.StateManagement;

namespace UETrack.Application.Web.Areas.UM.Controllers
{
    public class UserShiftLeaveDetailsController : Controller
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        // GET: UM/UserShiftLeaveDetails
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 0;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            //return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Add()
        {

            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.CurrentID = id;
            ViewBag.ActionType = nameof(Edit);
            return View("Detail");
        }

        public ActionResult view(int id)
        {
            ViewBag.CurrentID = id;
            ViewBag.ActionType = nameof(View); 
            return View("Detail");

        }
    }
}