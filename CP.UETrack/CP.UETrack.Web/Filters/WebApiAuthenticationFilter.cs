using System.Web;
using System.Net.Http;
using System.Net;
using CP.UETrack.Model;
using UETrack.Application.Web.Helpers;
using CP.Framework.Common.StateManagement;

namespace CP.UETrack.Application.Web.Filter
{
    public class WebApiAuthenticationAttribute : System.Web.Http.Filters.ActionFilterAttribute
    {
        public override void OnActionExecuting(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            var request = actionContext.Request;

            var ctx = default(HttpContext);
            ctx = HttpContext.Current; 
            base.OnActionExecuting(actionContext);
            if (!ctx.User.Identity.IsAuthenticated)
            {
                var transactionInformation = new TransactionalInformation();
                transactionInformation.ReturnMessage.Add("Your session has expired.");
                transactionInformation.ReturnStatus = false;
                actionContext.Response = request.CreateResponse<TransactionalInformation>(HttpStatusCode.Unauthorized, transactionInformation);
            }
        }
    }
}