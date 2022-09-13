using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/pPMLoadBalancing")]
    [WebApiAudit]
    public class PPMLoadBalancingAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(PPMLoadBalancingAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("pPMLoadBalancing/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetWorkOrderDetails))]
        public async Task<HttpResponseMessage> GetWorkOrderDetails(PPMLoadBalancingFetch loadBalancingFetch)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
            var result = await RestHelper.ApiPost("pPMLoadBalancing/GetWorkOrderDetails", loadBalancingFetch);
            Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetWorkOrders))]
        public async Task<HttpResponseMessage> GetWorkOrders(PPMLoadBalancingWorkOrder loadBalancingWorkOrder)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrders), Level.Info.ToString());
            var result = await RestHelper.ApiPost("pPMLoadBalancing/GetWorkOrders", loadBalancingWorkOrder);
            Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrders), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] PPMLoadBalancingWorkOrders pPMLoadBalancing)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("pPMLoadBalancing/Save", pPMLoadBalancing);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
    }
}
