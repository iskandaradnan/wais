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

    [RoutePrefix("api/unblockUser")]
    [WebApiAudit]
    public class UnblockUserApiController : BaseApiController
    {
        private readonly string _FileName = nameof(UnblockUserApiController);

        public UnblockUserApiController()
        {
            
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("unblockUser/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] UMUserRegistration unblockUser)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("unblockUser/Save", unblockUser);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(BlockingList))]
        public async Task<HttpResponseMessage> BlockingList(string IdList)
        {
            
            Log4NetLogger.LogEntry(_FileName, nameof(BlockingList), Level.Info.ToString());
            var result = await RestHelper.ApiGet("unblockUser/BlockingList?IdList=" + IdList);
            Log4NetLogger.LogEntry(_FileName, nameof(BlockingList), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("unblockUser/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("unblockUser/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("unblockUser/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetUserRoles/{Id}")]
        public async Task<HttpResponseMessage> GetUserRoles(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("unblockUser/GetUserRoles/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetLocations/{Id}")]
        public async Task<HttpResponseMessage> GetLocations(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("unblockUser/GetLocations/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            return result;
        }

        public class UnblockList
        {
        }
    }
}
