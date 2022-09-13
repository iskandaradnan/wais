using UETrack.Application.Web.Helpers;
using CP.UETrack.Model.CLS;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using System.Reflection;

namespace UETrack.Application.Web.API.CLS
{
    [RoutePrefix("api/JIDetails")]
    [WebApiAudit]
    public class JIDetailsApiController : BaseApiController
    {
        private readonly string _FileName = nameof(JIDetailsApiController);

        public JIDetailsApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("JIDetails/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] JIDetails jIDetails)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("JIDetails/Save", jIDetails);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Submit))]
        public async Task<HttpResponseMessage> Submit(HttpRequestMessage request, [FromBody] JIDetails jIDetail)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("JIDetails/Submit", jIDetail);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(LocationCodeFetch))]
        public Task<HttpResponseMessage> LocationCodeFetch(JIDetails AD)
        {
            Log4NetLogger.LogEntry(GetType().Name, nameof(LocationCodeFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("JIDetails/LocationCodeFetch", AD);
            Log4NetLogger.LogExit(GetType().Name, nameof(LocationCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("JIDetails/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(AttachmentSave))]
        public async Task<HttpResponseMessage> AttachmentSave(HttpRequestMessage request, [FromBody] JIDetails jIDetails)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
            var result = await RestHelper.ApiPost("JIDetails/AttachmentSave", jIDetails);
            Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("JIDetails/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(DocumentNoFetch))]
        public async Task<HttpResponseMessage> DocumentNoFetch(HttpRequestMessage request, [FromBody] JISchedule SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DocumentNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("JIDetails/DocumentNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(DocumentNoFetch), Level.Info.ToString());
            return result;
        }
    }
}