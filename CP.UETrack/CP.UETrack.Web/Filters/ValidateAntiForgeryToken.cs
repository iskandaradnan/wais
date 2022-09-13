using System.Linq;

namespace CP.UETrack.Application.Web.Filter
{
    public sealed class ValidateAntiForgeryToken : System.Web.Http.Filters.ActionFilterAttribute
    {
        public override void OnActionExecuting(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            var request = actionContext.Request;
            var headers = request.Headers;

            //if ((request.Method.ToString() == "POST" || request.Method.ToString() == "PUT") && headers.Contains("_RequestVerificationToken"))
                if (headers.Contains("_RequestVerificationToken"))
                {
                // Anti forgery token made as mandatory.
                var tokenHeaders = headers.GetValues("_RequestVerificationToken").FirstOrDefault();
                var cookieToken = string.Empty;
                var formToken = string.Empty;

                var tokens = tokenHeaders.Split(':');
                if (tokens.Length == 2)
                {
                    cookieToken = tokens[0].Trim();
                    formToken = tokens[1].Trim();

                }
                System.Web.Helpers.AntiForgery.Validate(cookieToken, formToken); 
            }

        }

    }

}
