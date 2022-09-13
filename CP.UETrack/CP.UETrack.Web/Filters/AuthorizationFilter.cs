using System;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;
using CP.UETrack.Application.Web.Helper;
using CP.Framework.Common.StateManagement;

namespace CP.UETrack.Application.Web.Filter
{
    public sealed class AuthorizationAction : AuthorizeAttribute
    {
        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            var controllerName = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
            var actionName = filterContext.ActionDescriptor.ActionName;

            if (!AuthorizationServiceHelperNew.HasPermission(controllerName, actionName))
            {
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new
                {
                    action = "Index",
                    controller = "Unauthorised",
                    area = ""
                }));
            }
        }
    }
}
