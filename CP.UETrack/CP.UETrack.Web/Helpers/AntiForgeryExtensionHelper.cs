
using System;
using System.Web.Mvc;

namespace CP.UETrack.Application.Web.Helper
{
    /// <summary>
    /// To genarate antiforgery token
    /// </summary>
    public static class AntiForgeryExtensionHelper
    {

        public static string GetRequestVerificationToken(this HtmlHelper helper)
        {
            return String.Format("ncg-request-verification-token={0}", GetTokenHeaderValue());
        }

        private static string GetTokenHeaderValue()
        {
            string cookieToken, formToken;
            System.Web.Helpers.AntiForgery.GetTokens(null, out cookieToken, out formToken);
            return cookieToken + ":" + formToken;
        }
    }
}
