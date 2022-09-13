using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.HWMS
{
    public class HWMSAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(HWMS);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "HWMS_default_Lan",
                  "{language}/HWMS/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(HWMS), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.HWMS.Controllers" }
              );
            context.MapRoute(
                "HWMS_default",
                "HWMS/{controller}/{action}/{id}",
               defaults: new { Service = nameof(HWMS), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.HWMS.Controllers" }
            );
        }
    }
}