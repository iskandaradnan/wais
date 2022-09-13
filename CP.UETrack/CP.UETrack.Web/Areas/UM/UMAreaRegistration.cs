using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.UM
{
    public class UMAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return nameof(UM);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "UM_default_Lan",
                "{language}/UM/{controller}/{action}/{id}",
                defaults: new { Service = nameof(UM), controller = "Home", action = "Index", id = UrlParameter.Optional },
                namespaces: new[] { "UETrack.Application.Web.Areas.UM.Controllers" }
            );

            context.MapRoute(
                "UM_default",
                "UM/{controller}/{action}/{id}",
                defaults: new { Service = nameof(UM), controller = "Home", action = "Index", id = UrlParameter.Optional, language = string.Empty },
                namespaces: new[] { "UETrack.Application.Web.Areas.UM.Controllers" }
            );
        }
    }
}