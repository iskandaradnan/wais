using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.CLS
{
    public class CLSAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(CLS);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "CLS_default_Lan",
                  "{language}/CLS/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(CLS), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.CLS.Controllers" }
              );
            context.MapRoute(
                "CLS_default",
                "CLS/{controller}/{action}/{id}",
               defaults: new { Service = nameof(CLS), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.CLS.Controllers" }
            );
        }
    }
}