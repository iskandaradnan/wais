using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model.VM;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.VM
{
    [WebApiAuthentication]
    [RoutePrefix("api/BulkAuthorization")]
    public class BulkAuthorizationAPIController : BaseApiController
    {
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = await RestHelper.ApiGet("BulkAuthorization/Load");
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("Save")]
        public Task<HttpResponseMessage> Post(BulkAuthorizationViewModel BulkAuthorization)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("BulkAuthorization/Save", BulkAuthorization);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("get/{Year}/{Month}/{ServiceId}/{PageSize}/{PageIndex}")]
        public Task<HttpResponseMessage> Get(int Year, int Month, int ServiceId, int PageSize, int PageIndex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("BulkAuthorization/get/{0}/{1}/{2}/{3}/{4}", Year, Month, ServiceId, PageSize, PageIndex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
    }
}
