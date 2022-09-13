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

    [RoutePrefix("api/reportsAndRecords")]
    [WebApiAudit]
    public class ReportsAndRecordsAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(ReportsAndRecordsAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("reportsAndRecords/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpGet("FetchRecords/{Year}/{Month}")]
        public async Task<HttpResponseMessage> FetchRecords(int Year, int Month)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("reportsAndRecords/FetchRecords/{0}/{1}", Year, Month));
            Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] ReportsAndRecordsLst repotsAndRecordsList)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("reportsAndRecords/Save", repotsAndRecordsList);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("reportsAndRecords/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("reportsAndRecords/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetWorkOrderDetails/{Id}")]
        public async Task<HttpResponseMessage> GetWorkOrderDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("reportsAndRecords/GetWorkOrderDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetCARHistoryDetails/{Id}")]
        public async Task<HttpResponseMessage> GetCARHistoryDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetCARHistoryDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("reportsAndRecords/GetCARHistoryDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetCARHistoryDetails), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveWorkOrderDetails))]
        public async Task<HttpResponseMessage> SaveWorkOrderDetails(CARWorkOrderList carWorkOrderList)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveWorkOrderDetails), Level.Info.ToString());
            var result = await RestHelper.ApiPost("reportsAndRecords/SaveWorkOrderDetails", carWorkOrderList);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveWorkOrderDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("reportsAndRecords/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetRootCauses/{Id}")]
        public async Task<HttpResponseMessage> GetRootCauses(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetRootCauses), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("reportsAndRecords/GetRootCauses/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetRootCauses), Level.Info.ToString());
            return result;
        }
    }
}
