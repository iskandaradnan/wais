using CP.UETrack.Application.Web.Filter;
using CP.Framework.Common.Audit;
using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    [AuthenicationAction]
    [WebAudit]
    //[AuthorizationAction]
    public class DialysisController : Controller
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        private string _ErrorMessage = string.Empty;
        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 1;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            ViewBag.ClassificationCode = "dialysis";
            ViewBag.ClassificationName = "Dialysis";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/List.cshtml");
        }
        
        public ActionResult Add()
        {
            ViewBag.CurrentID = 0;
            ViewBag.ARActionType = nameof(Add);
            ViewBag.AssetClassification = 2;
            ViewBag.ClassificationCode = "dialysis";
            ViewBag.ClassificationName = "Dialysis";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }
       
        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ARActionType = nameof(Edit);
            ViewBag.AssetClassification = 2;
            ViewBag.ClassificationCode = "dialysis";
            ViewBag.ClassificationName = "Dialysis";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }
       
        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ARActionType = nameof(View);
            ViewBag.AssetClassification = 2;
            ViewBag.ClassificationCode = "dialysis";
            ViewBag.ClassificationName = "Dialysis";
            return View("~/Areas/BEMS/Views/Shared/AssetRegister/Detail.cshtml");
        }
    }
}