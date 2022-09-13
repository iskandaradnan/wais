namespace UETrack.Application.Web.Controllers
{
    using CP.UETrack.Application.Web.Helper;
    using System.Threading.Tasks;
    using System.Web.Mvc;
    using Helpers;
    using CP.UETrack.Models;
    using System.Web;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System;
    using CP.Framework.Common.Logging;
    using CP.UETrack.Model;

    //[Authorize]
    public class AccountController : Controller
    {
        private readonly string fileName = nameof(AccountController);      
        public AccountController()
        {
        }

        //
        // GET: /Account/Login
        [AllowAnonymous]
        [OutputCache(Duration = 7200, VaryByParam = "none")]
        public ActionResult Login(string returnUrl)
        {
            CP.Framework.Security.Authentication.AuthenticationService.SignOut();
            ViewBag.ReturnUrl = returnUrl;
            Session.Abandon();
            return View("Authentication");
        }
        [AllowAnonymous]
        [OutputCache(Duration = 7200, VaryByParam = "none")]
        public ActionResult External_Login(string returnUrl)
        {
            CP.Framework.Security.Authentication.AuthenticationService.SignOut();
            ViewBag.ReturnUrl = returnUrl;
            Session.Abandon();
            return View("External_Authentication");
        }

        /// <summary>
        /// Log off
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        public async Task<ActionResult> Logoff()
        {
           var _UserSession = new SessionHelper().UserSession();
            var ActionName = nameof(Login);
            if (_UserSession.AccessLevel == 4)
            {
                ActionName = "external_Login";
            }
            //var sessionId = Session.SessionID;
            //var UserLoginObj = new AboutModel {sessionId = sessionId, loginType = 0 };
            //var SignOutDetails = new { sessionId = sessionId, loginType = 0 };
            //var UserSessionLoginResult = RestHelper.ApiPost("account/UserSessionLogin", UserLoginObj);
            CP.Framework.Security.Authentication.AuthenticationService.SignOut();
            Session.Abandon();
            var userName = System.Web.HttpContext.Current.User.Identity.Name;
            NavigationHelper.ClearUserPermissionsCacheData(userName);
            Response.Cookies.Add(new HttpCookie("ASP.NET_SessionId", ""));
            //NavigationHelper.ClearMultiLoginCacheData(userName);
            return RedirectToAction(ActionName, "Account");
        }

        //[AllowAnonymous]
        //public void Logout(string sessionid = "")
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(Logout), Level.Info.ToString());
        //        var UserLogoutObj = new AboutModel { sessionId = sessionid, loginType = 0 };
        //        using (var httpClient = new HttpClient())
        //        {
        //            httpClient.BaseAddress = new System.Uri(RestHelper.ApiBaseUri);
        //            httpClient.DefaultRequestHeaders.Accept.Clear();
        //            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            var json = "";
        //            json = Newtonsoft.Json.JsonConvert.SerializeObject(UserLogoutObj);
        //            var stringContent = new StringContent(json, System.Text.Encoding.UTF8, "application/json");
        //            var responseMessage = httpClient.PostAsync("account/UserSessionLogin/", stringContent).Result;
        //            stringContent.Dispose();
        //        }
        //        Log4NetLogger.LogExit(fileName, nameof(Logout), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        Log4NetLogger.LogExit(fileName, ex.Message, Level.Info.ToString());
        //    }

        //}
    }
}