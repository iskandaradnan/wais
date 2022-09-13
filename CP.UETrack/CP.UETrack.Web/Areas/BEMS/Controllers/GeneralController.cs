using CP.UETrack.Application.Web.Filter;
using CP.Framework.Common.Audit;
using System.Web.Mvc;
using System.Configuration;
using System.IO;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    [AuthenicationAction]
    [WebAudit]
    //[AuthorizationAction]
    public class GeneralController : Controller
    {
        private string _ErrorMessage = string.Empty;
        public ActionResult Index()
        {
            ViewBag.ClassificationCode = "general";
            ViewBag.ClassificationName = "General";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/List.cshtml");
        }
        
        public ActionResult Add()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ARActionType = nameof(Add);
            ViewBag.AssetClassification = 1;
            ViewBag.ClassificationCode = "general";
            ViewBag.ClassificationName = "General";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }
       
        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ARActionType = nameof(Edit);
            ViewBag.AssetClassification = 1;
            ViewBag.ClassificationCode = "general";
            ViewBag.ClassificationName = "General";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }
       
        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ARActionType = nameof(View);
            ViewBag.AssetClassification = 1;
            ViewBag.ClassificationCode = "general";
            ViewBag.ClassificationName = "General";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }

        
        //***************** Common File Download *********************
        

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
                FileName= FileName + ext;
                return File(finalpath, ContentType, FileName);
            }
            else
            {
                return Content("Invalid File....", "text/plain");
            }
        }
    }
}