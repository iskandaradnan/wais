using System.Web.Mvc;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.Areas.FEMS
{
    public class FEMSAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(FEMS);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "FEMS_default_Lan",
                  "{language}/FEMS/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(FEMS), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.FEMS.Controllers" }
              );
            context.MapRoute(
                "FEMS_default",
                "FEMS/{controller}/{action}/{id}",
               defaults: new { Service = nameof(FEMS), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.FEMS.Controllers" }
            );
        }
    }
}