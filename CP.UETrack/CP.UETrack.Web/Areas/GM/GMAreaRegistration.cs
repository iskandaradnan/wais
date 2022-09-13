using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.GM
{
    public class GMAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(GM);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "GM_default_Lan",
                  "{language}/GM/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(GM), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.GM.Controllers" }
              );
            context.MapRoute(
                "GM_default",
                "GM/{controller}/{action}/{id}",
               defaults: new { Service = nameof(GM), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.GM.Controllers" }
            );
        }
    }
}