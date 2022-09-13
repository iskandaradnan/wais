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

    [RoutePrefix("api/kPITransactionMapping")]
    [WebApiAudit]
    public class KPITransactionMappingAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(KPITransactionMappingAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("kPITransactionMapping/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FetchRecords))]
        public async Task<HttpResponseMessage> FetchRecords(KPITransactionMapping kPITransactionMapping)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
            var result = await RestHelper.ApiPost("kPITransactionMapping/FetchRecords", kPITransactionMapping);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(KPITransactions kpiTransactions)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("kPITransactionMapping/Save", kpiTransactions);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("kPITransactionMapping/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}/{PageIndex}/{PageSize}")]
        public async Task<HttpResponseMessage> Get(int Id, int PageIndex, int PageSize)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("kPITransactionMapping/Get/{0}/{1}/{2}", Id, PageIndex, PageSize));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("kPITransactionMapping/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
    }
}
