
using System.Web.Mvc;


namespace UETrack.Application.Web.Areas.Reports
{
    public class ReportsAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(Reports);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "Reports_default_Lan",
                  "{language}/Reports/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(Reports), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.Reports.Controllers" }
              );
            context.MapRoute(
                "Reports_default",
                "Reports/{controller}/{action}/{id}",
               defaults: new { Service = nameof(Reports), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.Reports.Controllers" }
            );
        }
    }
}