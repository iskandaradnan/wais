using UETrack.Application.Web.Helpers;
using CP.UETrack.Model.HWMS;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.CLS;
using System.Reflection;

namespace UETrack.Application.Web.API.CLS
{
    [RoutePrefix("api/JIScheduleGeneration")]
    [WebApiAudit]
    public class JIScheduleGenerationApiController : BaseApiController
    {
        private readonly string _FileName = nameof(JIScheduleGenerationApiController);

        public JIScheduleGenerationApiController()
        {
        }       
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] JIScheduleGeneration generation)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("JIScheduleGeneration/Save", generation);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetYear))]
        public async Task<HttpResponseMessage> GetYear()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetYear), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("JIScheduleGeneration/GetYear?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetYear), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetMonth/{Year}")]
        public async Task<HttpResponseMessage> GetMonth(int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetMonth), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("JIScheduleGeneration/GetMonth/{0}", Year));
            Log4NetLogger.LogEntry(_FileName, nameof(GetMonth), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetWeek/{YearMonth}")]
        public async Task<HttpResponseMessage> GetWeek(string YearMonth)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetWeek), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("JIScheduleGeneration/GetWeek/{0}", YearMonth));
            Log4NetLogger.LogEntry(_FileName, nameof(GetWeek), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("JIScheduleGeneration/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("JIScheduleGeneration/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("JIScheduleGeneration/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("JIScheduleGeneration/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(UserFetch))]
        public Task<HttpResponseMessage> UserFetch(JIScheduleGeneration AD)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("JIScheduleGeneration/UserFetch", AD);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
    }
}