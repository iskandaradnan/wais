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

    [RoutePrefix("api/userRegistration")]
    [WebApiAudit]
    public class UserRegistrationApiController : BaseApiController
    {
        private readonly string _FileName = nameof(UserRegistrationApiController);

        public UserRegistrationApiController()
        {
            
        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("userRegistration/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] UMUserRegistration userRegistration)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("userRegistration/Save", userRegistration);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("userRegistration/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("userRegistration/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("userRegistration/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetUserRoles/{Id}")]
        public async Task<HttpResponseMessage> GetUserRoles(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("userRegistration/GetUserRoles/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetLocations/{Id}")]
        public async Task<HttpResponseMessage> GetLocations(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetLocations), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("userRegistration/GetLocations/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetLocations), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAllLocations))]
        public async Task<HttpResponseMessage> GetAllLocations()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAllLocations), Level.Info.ToString());
            var result = await RestHelper.ApiGet("userRegistration/GetAllLocations");
            Log4NetLogger.LogEntry(_FileName, nameof(GetAllLocations), Level.Info.ToString());
            return result;
        }

    }
}
