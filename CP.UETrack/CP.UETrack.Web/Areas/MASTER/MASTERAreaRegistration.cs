using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.MASTER
{
    public class MASTERAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(MASTER);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "MASTER_default_Lan",
                  "{language}/MASTER/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(MASTER), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.MASTER.Controllers" }
              );
            context.MapRoute(
                "MASTER_default",
                "MASTER/{controller}/{action}/{id}",
               defaults: new { Service = nameof(MASTER), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.MASTER.Controllers" }
            );
        }
    }
}