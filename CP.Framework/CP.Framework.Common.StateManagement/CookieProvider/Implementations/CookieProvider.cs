using System;
using System.Web;

namespace CP.Framework.Common.StateManagement
{

    public class CookieProvider : ICookieProvider
    {

        /// <summary>
        ///
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="cookieValue"></param>
        /// <param name="cookieTimeout"></param>
        /// <param name="NonPersistent"></param>
        public void WriteCookie(string cookieName, string cookieValue, int cookieTimeout, bool NonPersistent)
        {

            var Cookie = new HttpCookie(cookieName, cookieValue);

            if (!NonPersistent)
                Cookie.Expires = DateTime.Now.AddHours(cookieTimeout);
            var encodedCookie = HttpSecureCookie.Encode(Cookie);
            HttpContext.Current.Response.Cookies.Add(encodedCookie);

        }

        /// <summary>
        ///
        /// </summary>
        /// <param name="cookieName"></param>
        /// <returns></returns>
        public string ReadCookie(string cookieName)
        {
            var bCookie = HttpContext.Current.Request.Cookies[cookieName];
            if (bCookie == null)
            {
                return "";
            }
            var Cookie = HttpContext.Current.Request.Cookies[cookieName];
            var decodedCookie = HttpSecureCookie.Decode(Cookie);
            return (string)decodedCookie.Value;
        }

          /// <summary>
        ///
        /// </summary>
        /// <param name="cookieName"></param>
        /// <returns></returns>
        public void ClearCookie(string cookieName)
        {
           HttpContext.Current.Response.Cookies[cookieName].Expires = DateTime.Now.AddDays(-1);
        }

        public bool IsCookiesAvailable(string cookieName)
        {
            var objcookie = HttpContext.Current.Request.Cookies[cookieName];
            return objcookie != null;
        }

    }
}
