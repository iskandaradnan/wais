using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
            
            HttpCookie Cookie = new HttpCookie(cookieName, cookieValue);

            if (!NonPersistent)
                Cookie.Expires = DateTime.Now.AddHours(cookieTimeout); 
            HttpCookie encodedCookie = HttpSecureCookie.Encode(Cookie);
            HttpContext.Current.Response.Cookies.Add(encodedCookie);
            
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <returns></returns>
        public string ReadCookie(string cookieName)
        {
            HttpCookie bCookie = HttpContext.Current.Request.Cookies[cookieName];
            if (bCookie == null)
            { 
                return ""; 
            }
            else
            {
                HttpCookie Cookie = HttpContext.Current.Request.Cookies[cookieName];
                HttpCookie decodedCookie = HttpSecureCookie.Decode(Cookie);
                return (string)decodedCookie.Value;
            }
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
            HttpCookie objcookie = HttpContext.Current.Request.Cookies[cookieName];
            if (objcookie != null)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        
    }
}
