using CP.UETrack.CodeLib.Helpers;
using System.Web.Mvc;

namespace UETrack.Application.Web.Helpers
{
    public sealed class ErrorHelper : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            UETrackLogger.Log(filterContext.Exception);
        }
    }

}