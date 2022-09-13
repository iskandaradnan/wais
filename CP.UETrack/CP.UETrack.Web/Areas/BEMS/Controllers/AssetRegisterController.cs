using CP.Framework.Common.Audit;
using CP.UETrack.Application.Web.Filter;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    [AuthenicationAction]
    [WebAudit]
    //[AuthorizationAction]
     
    public class AssetRegisterController : Controller
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index(int Id = 0)
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.TestingAndCommissioningId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ARActionType = nameof(Add);
            return View("Detail");
            //return View("List");
        }
        public ActionResult Get(int Id = 0)
        {
            ViewBag.AssetId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ARActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Add(int Id = 0)
        {
            ViewBag.TestingAndCommissioningId = Id;
            ViewBag.CurrentID = 0;
            ViewBag.ARActionType = nameof(Add);
            return View("Detail");
        }
        //public ActionResult AddAsset(int Id)
        //{
        //    ViewBag.TestingAndCommissioningId = Id;
        //    ViewBag.CurrentID = 0;
        //    ViewBag.ActionType = nameof(Add);
        //    return View("Detail");
        //}
        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ARActionType = nameof(Edit);
            return View("Detail");
        }
        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ARActionType = nameof(View);
            return View("Detail");
        }

        //**************** Common File Download ********************


        [HttpPost]
        public ActionResult CommonDownLoad(FormCollection form)
        {
            var FileName = form.Get("FileName");
            var ContentType = form.Get("ContentType");
            var FilePath = form.Get("FilePath");
            var pathLocation = ConfigurationManager.AppSettings["FileUpload"];
            if (!Directory.Exists(pathLocation))
                Directory.CreateDirectory(pathLocation);

            var finalpath = Path.Combine(pathLocation, FilePath);
            string ext = Path.GetExtension(finalpath);
            var fileex = new FileInfo(finalpath);
            if (fileex.Exists)
            {
                FileName = FileName + ext;
                return File(finalpath, ContentType, FileName);
            }
            else
            {
                return Content("Invalid File....", "text/plain");
            }
        }
    }
}