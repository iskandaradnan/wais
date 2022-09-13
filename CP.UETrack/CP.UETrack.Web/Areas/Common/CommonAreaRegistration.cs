using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.Common
{
    public class CommonAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return nameof(Common);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "Common_default",
                "Common/{controller}/{action}/{id}",
                defaults: new { Service = nameof(Common), controller = "Home", action = "Index", id = UrlParameter.Optional },
                namespaces: new[] { "UETrack.Application.Web.Areas.Common.Controllers" }
            );
        }
    }
}