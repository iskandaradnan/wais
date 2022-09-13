using System.Web;

namespace CP.Framework.Common.StateManagement
{
    public static class HttpSecureCookie
    {

        public static HttpCookie Encode(HttpCookie cookie)
        {
            var encodedCookie = CloneCookie(cookie);
            encodedCookie.Value =
              MachineKeyCryptography.Encode(cookie.Value);
            return encodedCookie;
        }

        public static HttpCookie Decode(HttpCookie cookie)
        {
            var decodedCookie = CloneCookie(cookie);
            decodedCookie.Value =
              MachineKeyCryptography.Decode(cookie.Value);
            return decodedCookie;
        }

        public static HttpCookie CloneCookie(HttpCookie cookie)
        {
            var clonedCookie = new HttpCookie(cookie.Name, cookie.Value)
            {
                Domain = cookie.Domain,
                Expires = cookie.Expires,
                HttpOnly = cookie.HttpOnly,
                Path = cookie.Path,
                Secure = cookie.Secure
            };

            return clonedCookie;
        }
    }
}
