using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CP.Framework.Common.Audit
{
    public sealed class WebAuditAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var ctx = default(HttpContext);
            ctx = HttpContext.Current;

            base.OnActionExecuting(filterContext);

            IAuditViewModel model;
            foreach (var item in filterContext.ActionParameters)
            {
                if (item.Value is IAuditViewModel)
                {
                    model = item.Value as IAuditViewModel;
                    model.VisitedArea = ctx.Request.Url.ToString();
                    model.VisitedDateTime = DateTime.UtcNow.ToString();

                    var myRequest = ctx.Request;
                    //var strHostName = System.Net.Dns.GetHostName();
                    //var ipEntry = System.Net.Dns.GetHostAddresses(strHostName);
                    //var addr = ipEntry;
                    //var ip = addr[1].ToString();
                    //var ipEntry = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName());
                    //var ip = ipEntry.AddressList[1].ToString();
                    var ip = myRequest.ServerVariables["HTTP_X_FORWARDED_FOR"];
                    if (!string.IsNullOrEmpty(ip))
                    {
                        var ipRange = ip.Split(',');
                        var le = ipRange.Length - 1;
                        var trueIP = ipRange[le];
                    }
                    else
                    {
                        ip = myRequest.ServerVariables["REMOTE_ADDR"];
                    }
                    model.VisitorIP = ip;
                    if (HttpContext.Current.Session != null)
                    {
                        model.VisitorSession = HttpContext.Current.Session.SessionID;
                    }
                    var baseAssembly = filterContext.Controller.GetType().Assembly;

                    var results = from type in baseAssembly.GetTypes()
                                  where typeof(IAudit).IsAssignableFrom(type)
                                  select type;
                    var methodParam = new object[] { model };
                    foreach (var result in results)
                    {
                        var methodInfo = result.GetMethod("Save");
                        var classInstance = Activator.CreateInstance(result, null);
                        methodInfo.Invoke(classInstance, methodParam);
                    }
                }
            }

        }
    }
}
