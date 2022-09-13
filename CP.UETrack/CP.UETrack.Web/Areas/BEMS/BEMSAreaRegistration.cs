using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS
{
    public class BEMSAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(BEMS);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "BEMS_default_Lan",
                  "{language}/BEMS/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(BEMS), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.BEMS.Controllers" }
              );
            context.MapRoute(
                "BEMS_default",
                "BEMS/{controller}/{action}/{id}",
               defaults: new { Service = nameof(BEMS), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.BEMS.Controllers" }
            );
        }
    }
}