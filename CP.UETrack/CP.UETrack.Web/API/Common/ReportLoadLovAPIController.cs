using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.Common
{
    [WebApiAuthentication]
    [RoutePrefix("api/ReportLoadLov")]
    public class ReportLoadLovAPIController : BaseApiController
    {
        [System.Web.Http.HttpGetAttribute("Load/{screenname}")]
        public Task<HttpResponseMessage> Load(string screenname)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("BerOne/get/{0}", screenname));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
    }
}
