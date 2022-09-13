using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using UETrack.Application.Web.Helpers;

namespace CP.UETrack.Application.Web.Filter
{

    public class AuthenicationAction : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var ctx = default(HttpContext);
            ctx = HttpContext.Current;
       
            base.OnActionExecuting(context);

            if (!ctx.User.Identity.IsAuthenticated || !new SessionHelper().IsSessionExists())
            {                               
                context.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Account", action = "Login" }));               
            }
           
        }

    } 

}