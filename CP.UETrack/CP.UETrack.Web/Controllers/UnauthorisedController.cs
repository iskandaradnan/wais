using System.Web.Mvc;

namespace UETrack.Application.Web.Controllers
{
    public class UnauthorisedController : Controller
    {
        // GET: Unauthorised
        public ActionResult Index()
        {
            return View();
        }
    }
}