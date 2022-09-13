using System.Security.Principal;
using System.Web;
using System.Web.Security;
using CP.Framework.Security.Authentication.Models;

namespace CP.Framework.Security.Authentication
{
    public class AuthenticationService : IAuthenticationService
    {
        public void SignIn(string username, bool isPersistent)
        {

            var encryptedTicket = Ticket.CreateTicket(username, isPersistent);

            var decryptedTicket = FormsAuthentication.Decrypt(encryptedTicket);

            var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
            {
                HttpOnly = true,
                Expires = decryptedTicket.Expiration,
                Domain = "changepond.com",
                Name = "CPASISAuth",
                Path = "/",
                Secure = true
            };

            if (HttpContext.Current != null)
            {
                HttpContext.Current.Response.Cookies.Add(cookie);
                FormsAuthentication.SetAuthCookie(encryptedTicket, isPersistent);
            }
            return;
        }

        public static void SignOut()
        {

            FormsAuthentication.SignOut();
            return;
        }

        public void CreateCustomPrincipal()
        {
            if (HttpContext.Current.Request.IsAuthenticated)
            {
                var authCookie = HttpContext.Current.Request.Cookies[FormsAuthentication.FormsCookieName];
                if (authCookie != null)
                {
                    var authTicket = FormsAuthentication.Decrypt(FormsAuthentication.Decrypt(authCookie.Value).Name);
                    var identity = new GenericIdentity(authTicket.Name, "Forms");
                    var principal = new CustomPrincipal(identity);
                    HttpContext.Current.User = principal;
                }
            }
        }

        public string GetUserName()
        {
            return HttpContext.Current.User.Identity.Name;
        }
    }
}
