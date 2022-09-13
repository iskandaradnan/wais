
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.QAP
{
    public class QAPAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return nameof(QAP);
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                  "QAP_default_Lan",
                  "{language}/QAP/{controller}/{action}/{id}",
                  defaults: new { Service = nameof(QAP), controller = "Home", action = "Index", id = UrlParameter.Optional },
                  namespaces: new[] { "UETrack.Application.Web.Areas.QAP.Controllers" }
              );
            context.MapRoute(
                "QAP_default",
                "QAP/{controller}/{action}/{id}",
               defaults: new { Service = nameof(QAP), controller = "Home", action = "Index", id = UrlParameter.Optional },
               namespaces: new[] { "UETrack.Application.Web.Areas.QAP.Controllers" }
            );
        }
    }
}