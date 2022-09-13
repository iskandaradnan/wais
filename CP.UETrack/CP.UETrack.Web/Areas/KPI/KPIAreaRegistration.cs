using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.KPI
{
    public class KPIAreaRegistration: AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(KPI);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "KPI_default_Lan",
                  "{language}/KPI/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(KPI), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.KPI.Controllers" }
              );
            context.MapRoute(
                "KPI_default",
                "KPI/{controller}/{action}/{id}",
               defaults: new { Service = nameof(KPI), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.KPI.Controllers" }
            );
        }
    }
}