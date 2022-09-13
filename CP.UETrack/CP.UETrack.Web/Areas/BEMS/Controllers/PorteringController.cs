using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;


namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class AssettrackerController : Controller
    {
        // GET: BEMS/Portering
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();


        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            // return View(nameof(List));
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }
        //public ActionResult Add()
        //{
        //    ViewBag.CurrentID = 0;
        //    ViewBag.ActionType = nameof(Add);
        //    return View("Detail");
        //}
        public ActionResult Add(int Id = 0)
        {
            ViewBag.LoanerTestEquipmentBookingId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ARActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Edit(int Id)
        {

            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Edit);
            return View("Detail");
        }
        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(View);
            return View("Detail");
        }
        public ActionResult Approve(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = nameof(Approve);
            return View("Detail");
        }
    }
}