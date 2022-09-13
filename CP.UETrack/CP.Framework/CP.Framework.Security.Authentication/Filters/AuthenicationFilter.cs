using System;
using System.Web.Mvc;

namespace CP.Framework.Security.Authentication.Filters
{
    public sealed class Authenticate : AuthorizeAttribute, IActionFilter
    {
        public void OnActionExecuted(ActionExecutedContext filterContext)
        {

        }

        public void OnActionExecuting(ActionExecutingContext filterContext)
        {
             if (filterContext.HttpContext.User.Identity.IsAuthenticated)
                return;

            throw new Exception("User not authorized");
        }
    }

}

