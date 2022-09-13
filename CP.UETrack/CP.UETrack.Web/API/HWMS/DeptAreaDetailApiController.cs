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
    [RoutePrefix("api/DeptAreaDetail")]
    [WebApiAudit]
    public class DeptAreaDetailApiController : BaseApiController
    {
        private readonly string _FileName = nameof(DeptAreaDetailApiController);
        public DeptAreaDetailApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("DeptAreaDetail/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] DeptAreaDetails deptAreaDetail)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetail/Save", deptAreaDetail);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("DeptAreaDetail/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("DeptAreaDetail/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("UserAreaNameData/{UserAreaCode}")]
        public async Task<HttpResponseMessage> UserAreaNameData(string UserAreaCode)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("DeptAreaDetail/UserAreaNameData/{0}", UserAreaCode));
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("DeptAreaDetail/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(ItemCodeFetch))]
        public async Task<HttpResponseMessage> ItemCodeFetch(HttpRequestMessage request, [FromBody] ItemTable SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ItemCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetail/ItemCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(ItemCodeFetch), Level.Info.ToString());
            return result;
        }
    }
}