using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.VM
{
    public class VMAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return nameof(VM);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                  "VM_default_Lan",
                  "{language}/VM/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(VM), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.VM.Controllers" }
              );
            context.MapRoute(
                "VM_default",
                "VM/{controller}/{action}/{id}",
               defaults: new { Service = nameof(VM), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.VM.Controllers" }
            );
        }
    }
}