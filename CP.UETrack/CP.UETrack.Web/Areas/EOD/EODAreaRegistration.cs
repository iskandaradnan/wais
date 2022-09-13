using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.EOD
{
    public class EODAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return nameof(EOD);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                 "EOD_default_Lan",
                 "{language}/EOD/{controller}/{action}/{id}",
                 defaults: new { Service = nameof(EOD), controller = "Home", action = "Index", id = UrlParameter.Optional },
                 namespaces: new[] { "UETrack.Application.Web.Areas.EOD.Controllers" }
             );
            context.MapRoute(
                "EOD_default",
                "EOD/{controller}/{action}/{id}",
               defaults: new { Service = nameof(EOD), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.EOD.Controllers" }
            );
        }
    }
}