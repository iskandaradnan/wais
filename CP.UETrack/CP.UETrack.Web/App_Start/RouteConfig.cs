using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace UETrack.Application.Web
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //routes.MapRoute(
            //    name: "FEMSService",
            //    url: "FEMS/{controller}/{action}/{id}",
            //    defaults: new { Service = "FEMS", controller = "Home", action = "Index", id = UrlParameter.Optional }
            //);
            //routes.MapRoute(
            //    name: "BEMSService",
            //    url: "BEMS/{controller}/{action}/{id}",
            //    defaults: new { Service = "BEMS", controller = "Home", action = "Index", id = UrlParameter.Optional }
            //);
            //routes.MapRoute(
            //    name: "CLSService",
            //    url: "CLS/{controller}/{action}/{id}",
            //    defaults: new { Service = "CLS", controller = "Home", action = "Index", id = UrlParameter.Optional }
            //);
            //routes.MapRoute(
            //    name: "HWMSService",
            //    url: "HWMS/{controller}/{action}/{id}",
            //    defaults: new { Service = "HWMS", controller = "Home", action = "Index", id = UrlParameter.Optional }
            //);
            //routes.MapRoute(
            //    name: "LLSService",
            //    url: "LLS/{controller}/{action}/{id}",
            //    defaults: new { Service = "LLS", controller = "Home", action = "Index", id = UrlParameter.Optional }
            //);
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { Service = "FEMS", controller = "Home", action = "Index", id = UrlParameter.Optional },
                namespaces: new[] { "UETrack.Application.Web.Controllers" }
            );
        }
    }
}
