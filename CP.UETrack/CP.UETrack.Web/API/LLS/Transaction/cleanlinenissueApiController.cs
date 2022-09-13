using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.LLS;
using CP.UETrack.Application.Web.Filter;
using System.Reflection;
namespace UETrack.Application.Web.API.LLS.Transaction
{
    [WebApiAuthentication]
    [RoutePrefix("api/CleanLinenIssue")]
  
    public class CleanLinenIssueApiController : BaseApiController
    {
        // GET: cleanlinenissueApi
        private readonly string _FileName = nameof(CleanLinenIssueApiController);

        public CleanLinenIssueApiController()
        {

        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("CleanLinenIssue/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }



        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CleanLinenIssueModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CleanLinenIssue/Save", model);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CleanLinenIssue/GetAll?{0}", filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CleanLinenIssue/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        

        [HttpGet("GetByLinenItemDetails/{Id}")]
        public async Task<HttpResponseMessage> GetByLinenItemDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetByLinenItemDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CleanLinenIssue/GetByLinenItemDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetByLinenItemDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetByLinenBagDetails/{Id}")]
        public async Task<HttpResponseMessage> GetByLinenBagDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetByLinenBagDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CleanLinenIssue/GetByLinenBagDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetByLinenBagDetails), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetByScheduledId))]
        public async Task<HttpResponseMessage> GetByScheduledId(HttpRequestMessage request, [FromBody] CleanLinenIssueModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetByScheduledId), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CleanLinenIssue/GetByScheduledId", model);
            Log4NetLogger.LogEntry(_FileName, nameof(GetByScheduledId), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CleanLinenIssue/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
    }
}