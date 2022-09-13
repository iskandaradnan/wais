namespace UETrack.Application.Web
{
    using Helpers;
    using System;
    using System.Globalization;
    using System.Threading;
    using System.Web;
    using System.Web.Http;
    using System.Web.Mvc;
    using System.Web.Optimization;
    using System.Web.Routing;
    using System.Web.SessionState;
    using CP.UETrack.CodeLib.Helpers;
    using System.IO;
    using System.Threading.Tasks;

    public class MvcApplication : System.Web.HttpApplication
    {
       
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            UETrackLogger.Log("Global.Asax", "AppStart");

            InitWebApi();
            
        }

        protected void Application_End(object sender, EventArgs e)
        {
            UETrackLogger.Log("Global.Asax", "AppEnd");
        }

        protected void Application_PostAuthenticateRequest(Object sender, EventArgs e)
        {
            new CP.Framework.Security.Authentication.AuthenticationService().CreateCustomPrincipal();
            HttpContext.Current.SetSessionStateBehavior(SessionStateBehavior.Required);
        }

        protected void Application_BeginRequest(Object sender, EventArgs e)
        {
            var newCulture = (CultureInfo)System.Threading.Thread.CurrentThread.CurrentCulture.Clone();
            newCulture.DateTimeFormat.ShortDatePattern = "dd/MM/yyyy";
            newCulture.DateTimeFormat.DateSeparator = "/";
            Thread.CurrentThread.CurrentCulture = newCulture;
        }

       static async Task InitWebApi()
        {
            UETrackLogger.Log("Entry", nameof(InitWebApi));

            var x = await RestHelper.ApiGet(@"Home\HelloApi", true);
            var result = await x.Content.ReadAsStringAsync();
            UETrackLogger.Log("InitWebApi Result", x.StatusCode.ToString(), result);

            UETrackLogger.Log("Exit", nameof(InitWebApi));
        }

    }

}
