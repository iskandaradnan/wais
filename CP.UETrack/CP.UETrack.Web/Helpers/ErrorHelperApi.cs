namespace UETrack.Application.Web.Helpers
{
    using CP.UETrack.CodeLib.Helpers;
    using System.Web.Http.Filters;

    public sealed class ErrorHelperApi : ExceptionFilterAttribute
    {

        public override void OnException(HttpActionExecutedContext filterContext)
        {            
            UETrackLogger.Log(filterContext.Exception);
        }
    }
}