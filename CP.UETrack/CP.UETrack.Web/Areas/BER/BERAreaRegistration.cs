using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BER
{
    public class BERAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(BER);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "BER_default_Lan",
                  "{language}/BER/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(BER), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.BER.Controllers" }
              );
            context.MapRoute(
                "BER_default",
                "BER/{controller}/{action}/{id}",
               defaults: new { Service = nameof(BER), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.BER.Controllers" }
            );
        }
    }
}