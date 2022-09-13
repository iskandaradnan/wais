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

    [RoutePrefix("api/kpiGeneration")]
    [WebApiAudit]
    public class KPIGenerationAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(KPIGenerationAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("kpiGeneration/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetMonthlyServiceFee))]
        public async Task<HttpResponseMessage> GetMonthlyServiceFee(MonthlyServiceFeeFetch serviceFeeFetch)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetMonthlyServiceFee), Level.Info.ToString());
            var result = await RestHelper.ApiPost("kpiGeneration/GetMonthlyServiceFee", serviceFeeFetch);
            Log4NetLogger.LogEntry(_FileName, nameof(GetMonthlyServiceFee), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] KPIGeneration kpiGeneration)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("kpiGeneration/Save", kpiGeneration);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll(KPIGenerationFetch kpiGenerationFetch)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            //var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiPost("kpiGeneration/GetAll", kpiGenerationFetch);
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetAllRecords))]
        public async Task<HttpResponseMessage> GetAllRecords(KPIGenerationFetch kpiGenerationFetch)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAllRecords), Level.Info.ToString());
            var result = await RestHelper.ApiPost("kpiGeneration/GetAllRecords", kpiGenerationFetch);
            Log4NetLogger.LogEntry(_FileName, nameof(GetAllRecords), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetDemeritPoints))]
        public async Task<HttpResponseMessage> GetDemeritPoints(KPIGenerationFetch KpiGenerationFetch)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDemeritPoints), Level.Info.ToString());
            var result = await RestHelper.ApiPost("kpiGeneration/GetDemeritPoints", KpiGenerationFetch);
            Log4NetLogger.LogEntry(_FileName, nameof(GetDemeritPoints), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(GetDeductionValues))]
        public async Task<HttpResponseMessage> GetDeductionValues(KPIGenerationFetch KpiGenerationFetch)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDeductionValues), Level.Info.ToString());
            var result = await RestHelper.ApiPost("kpiGeneration/GetDeductionValues", KpiGenerationFetch);
            Log4NetLogger.LogEntry(_FileName, nameof(GetDeductionValues), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("kpiGeneration/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
    }
}
