namespace UETrack.Application.Web.API.Helpers
{
    using CP.UETrack.CodeLib.Helpers;
    using System.Web.Http.Filters;

    public class ErrorHelperApi : ExceptionFilterAttribute
    {
        
        public override void OnException(HttpActionExecutedContext filterContext)
        {
            UETrackLogger.Log(filterContext.Exception);
        }
    }
}