using UETrack.Application.Web.Helpers;
using CP.UETrack.Model.CLS;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;

namespace UETrack.Application.Web.API.CLS
{
    [RoutePrefix("api/CLSCorrectiveActionReport")]
    [WebApiAudit]
    public class CLSCorrectiveActionReportApiController : BaseApiController
    {
        private readonly string _FileName = nameof(CLSCorrectiveActionReportApiController);

        public CLSCorrectiveActionReportApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("CLSCorrectiveActionReport/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(AutoGeneratedCode))]
        public async Task<HttpResponseMessage> AutoGeneratedCode()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CLSCorrectiveActionReport/AutoGeneratedCode?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CARNoFetch))]
        public async Task<HttpResponseMessage> CARNoFetch(HttpRequestMessage request, [FromBody] CorrectiveActionReport SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CARNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSCorrectiveActionReport/CARNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CARNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CorrectiveActionReport correctiveActionReport)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSCorrectiveActionReport/Save", correctiveActionReport);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetCARHistoryDetails/{Id}")]
        public async Task<HttpResponseMessage> GetCARHistoryDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetCARHistoryDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CLSCorrectiveActionReport/GetCARHistoryDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetCARHistoryDetails), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(AttachmentSave))]
        public async Task<HttpResponseMessage> AttachmentSave(HttpRequestMessage request, [FromBody] CorrectiveActionReport correctiveActionReport)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSCorrectiveActionReport/AttachmentSave", correctiveActionReport);
            Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
            return result;
        }


        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CLSCorrectiveActionReport/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }



        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CLSCorrectiveActionReport/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
    }
}