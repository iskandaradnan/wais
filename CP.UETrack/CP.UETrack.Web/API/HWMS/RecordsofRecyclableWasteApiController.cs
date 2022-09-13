using UETrack.Application.Web.Helpers;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.HWMS;

namespace UETrack.Application.Web.API.HWMS
{
    [RoutePrefix("api/RecordsofRecyclableWaste")]
    [WebApiAudit]
    public class RecordsofRecyclableWasteApiController : BaseApiController
    {
        // GET: RecordsofRecyclableWasteApi
        private readonly string _FileName = nameof(RecordsofRecyclableWasteApiController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("RecordsofRecyclableWaste/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet("WasteCodeGet/{WasteType}")]
        public async Task<HttpResponseMessage> WasteCodeGet(string WasteType)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("RecordsofRecyclableWaste/WasteCodeGet/{0}", WasteType));
            Log4NetLogger.LogEntry(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CSWRSFetch))]
        public async Task<HttpResponseMessage> CSWRSFetch(HttpRequestMessage request, [FromBody] RecordsofRecyclableWaste RecordsofRecyclable)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CSWRSFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("RecordsofRecyclableWaste/CSWRSFetch", RecordsofRecyclable);
            Log4NetLogger.LogEntry(_FileName, nameof(CSWRSFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] RecordsofRecyclableWaste CWRSheet)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("RecordsofRecyclableWaste/Save", CWRSheet);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("RecordsofRecyclableWaste/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("RecordsofRecyclableWaste/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }


    }
}