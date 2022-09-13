using CP.UETrack.Application.Web.Filter;
using CP.Framework.Common.Audit;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    [AuthenicationAction]
    [WebAudit]
    //[AuthorizationAction]
    public class LifeSupportController : Controller
    {
        private string _ErrorMessage = string.Empty;
        public ActionResult Index()
        {
            ViewBag.ClassificationCode = "lifesupport";
            ViewBag.ClassificationName = "Life Support";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/List.cshtml");
        }
        
        public ActionResult Add()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ARActionType = nameof(Add);
            ViewBag.AssetClassification = 4;
            ViewBag.ClassificationCode = "lifesupport";
            ViewBag.ClassificationName = "Life Support";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }
       
        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ARActionType = nameof(Edit);
            ViewBag.AssetClassification = 4;
            ViewBag.ClassificationCode = "lifesupport";
            ViewBag.ClassificationName = "Life Support";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }
       
        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ARActionType = nameof(View);
            ViewBag.AssetClassification = 4;
            ViewBag.ClassificationCode = "lifesupport";
            ViewBag.ClassificationName = "Life Support";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }
    }
}