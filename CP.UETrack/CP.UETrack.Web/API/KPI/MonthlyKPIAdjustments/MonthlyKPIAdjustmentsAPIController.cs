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

    [RoutePrefix("api/monthlyKPIAdjustments")]
    [WebApiAudit]
    public class MonthlyKPIAdjustmentsAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(MonthlyKPIAdjustmentsAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("monthlyKPIAdjustments/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] MonthlyKPIAdjustments monthlyKPIAdjustments)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("monthlyKPIAdjustments/Save", monthlyKPIAdjustments);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(FetchRecords))]
        public async Task<HttpResponseMessage> FetchRecords(MonthlyKPIAdjustments monthlyKPIAdjustments)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
            var result = await RestHelper.ApiPost("monthlyKPIAdjustments/FetchRecords", monthlyKPIAdjustments);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetPostDemeritPoints))]
        public async Task<HttpResponseMessage> GetPostDemeritPoints(KPIGenerationFetch KpiGenerationFetch)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetPostDemeritPoints), Level.Info.ToString());
            var result = await RestHelper.ApiPost("monthlyKPIAdjustments/GetPostDemeritPoints", KpiGenerationFetch);
            Log4NetLogger.LogEntry(_FileName, nameof(GetPostDemeritPoints), Level.Info.ToString());
            return result;
        }
    }
}
