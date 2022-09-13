using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.SmartAssignF
{
    public class SmartAssignAreaRegistration: AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(SmartAssign);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "SmartAssign_default_Lan",
                "{language}/SmartAssign/{controller}/{action}/{id}",
                defaults: new { Service = nameof(SmartAssign), controller = "Home", action = "Index", id = UrlParameter.Optional },
                namespaces: new[] { "UETrack.Application.Web.Areas.SmartAssign.Controllers" }
            );

            context.MapRoute(
                "SmartAssign_default",
                "SmartAssign/{controller}/{action}/{id}",
                defaults: new { Service = nameof(SmartAssign), controller = "Home", action = "Index", id = UrlParameter.Optional, language = string.Empty },
                namespaces: new[] { "UETrack.Application.Web.Areas.SmartAssign.Controllers" }
            );
        }
    }
}

