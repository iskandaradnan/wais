using CP.UETrack.CodeLib.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Logging;
using System;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
namespace UETrack.Application.Web.API.Core
{
    //http://arcware.net/logging-web-api-requests/
    public class ApiLogHandler : DelegatingHandler
    {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
   {
            var begin = DateTime.Now;
            var uri = request.RequestUri.ToString();
            var loginName = string.Empty;
            var reqHeaders = request.Headers;
            if (reqHeaders != null)
            {
                try
                {
                    var userinfo = reqHeaders.GetValues(nameof(UserDetailsModel));
                    if (userinfo != null)
                    {
                        var jss = new JavaScriptSerializer();
                        var userObj = jss.Deserialize<UserDetailsModel>(userinfo.FirstOrDefault());
                        loginName = userObj.UserName;
                    }
                }
                catch
                {
                    //do nothing
                }
            }

            var logStartInfo = string.Format(", {0}, {1}, \"{2}\", {3},", nameof(ApiLogHandler), loginName, uri, begin.ToString("HH:mm:ss"));
            writeLog(logStartInfo);

            return base.SendAsync(request, cancellationToken).ContinueWith(task =>
            {
                var response = task.Result;
                var end = DateTime.Now;
                var tt = end.Subtract(begin);
                var logInfo = string.Format(", {0}, {1}, \"{2}\", {3}, {4}, {5}, {6},", nameof(ApiLogHandler), loginName, uri, begin.ToString("HH:mm:ss"), end.ToString("HH:mm:ss"), tt.TotalSeconds.ToString(), response.StatusCode);
                writeLog(logInfo);
                return response;
            });
        }
        static void writeLog(string logInfo)
        {
            UETrackLogger.Log(nameof(ApiLogHandler), logInfo);
        }
    }
}