using System;
using System.Linq;
using System.Web;
using System.Web.Http.Filters;


namespace CP.Framework.Common.Audit
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Interface, AllowMultiple = false, Inherited = true)]
    public sealed class WebApiAuditAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(System.Web.Http.Controllers.HttpActionContext actionContext)
        {
            IAuditViewModel model;
            foreach (var item in actionContext.ActionArguments)
            {
                if (item.Value is IAuditViewModel)
                {
                    model = item.Value as IAuditViewModel;
                    model.VisitedArea = actionContext.Request.RequestUri.ToString() +"/"+ actionContext.Request.Method.Method;
                    model.VisitedDateTime = DateTime.UtcNow.ToString();

                    var myRequest = ((HttpContextWrapper)actionContext.Request.Properties["MS_HttpContext"]).Request;
                    //string clientAddress = HttpContext.Current.Request.UserHostAddress;
                    //var strHostName = System.Net.Dns.GetHostName();
                    //var ipEntry = System.Net.Dns.GetHostAddresses(strHostName);
                    //var ipEntry = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName());                    
                    //var ip = ipEntry.AddressList[1].ToString();
                    //var ip = clientAddress;
                    
                    //added for retreiving Client Ip address 
                    var context = HttpContext.Current;
                    var reqHeaders = context.Request.Headers;
                    var Visitorip = reqHeaders.GetValues("VisitorIp");
                    if (Visitorip != null)
                    {
                        model.VisitorIP = Visitorip[0];

                    }
                    else {
                        model.VisitorIP= myRequest.ServerVariables["REMOTE_ADDR"];
                    }
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
                   // model.VisitorIP = ip;
                    if (HttpContext.Current.Session != null)
                    {
                        model.VisitorSession = HttpContext.Current.Session.SessionID;
                    }
                    var baseAssembly = actionContext.ControllerContext.Controller.GetType().Assembly;

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

        public Audit audit { get; set; }

    }

}