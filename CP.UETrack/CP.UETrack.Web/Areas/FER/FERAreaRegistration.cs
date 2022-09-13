using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.FER
{
    public class FERAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(FER);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "FER_default_Lan",
                  "{language}/FER/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(FER), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.FER.Controllers" }
              );
            context.MapRoute(
                "FER_default",
                "FER/{controller}/{action}/{id}",
               defaults: new { Service = nameof(FER), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.FER.Controllers" }
            );
        }
    }
}