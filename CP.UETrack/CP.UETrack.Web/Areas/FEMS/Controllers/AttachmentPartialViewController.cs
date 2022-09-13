using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.UETrack.Application.Web.Filter;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    [AuthenicationAction]
    public class AttachmentPartialViewController : Controller
    {
        // GET: FEMS/AttachmentPartialView
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        public ActionResult Index()
        {

            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            return View();
        }

        //**************** Common File Download ********************


        [HttpPost]
        public ActionResult CommonDownLoad(FormCollection form)
        {

            var FileName = form.Get("FileName");
            var ContentType = form.Get("ContentType");
            var FilePath = form.Get("FilePath");

            var pathLocation = System.Web.Hosting.HostingEnvironment.MapPath("~/Attachments");

            // var pathLocation = ConfigurationManager.AppSettings["FileUpload"];

            if (!Directory.Exists(pathLocation))
                Directory.CreateDirectory(pathLocation);

            var finalpath = Path.Combine(pathLocation, FilePath);
            string ext = Path.GetExtension(finalpath);
            var fileex = new FileInfo(finalpath);
            if (fileex.Exists)
            {
                FileName = FileName + "_" + DateTime.Now.ToString("dd_MMM_yyyy") + ext;
                return File(finalpath, ContentType, FileName);
            }
            else
            {
                return Content("Invalid File....", "text/plain");
            }
        }
    }
}