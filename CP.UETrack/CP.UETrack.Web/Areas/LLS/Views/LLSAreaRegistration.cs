using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.LLS
{
    public class LLSAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(LLS);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "LLS_default_Lan",
                  "{language}/LLS/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(LLS), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.LLS.Controllers" }
              );
            context.MapRoute(
                "LLS_default",
                "LLS/{controller}/{action}/{id}",
               defaults: new { Service = nameof(LLS), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.LLS.Controllers" }
            );
        }
    }
}