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

    [RoutePrefix("api/roleScreenPermission")]
    [WebApiAudit]
    public class RoleScreenPermissionApiController : BaseApiController
    {
        private readonly string _FileName = nameof(RoleScreenPermissionApiController);

        public RoleScreenPermissionApiController()
        {
            
        }
        [HttpGet(nameof(GetUserRoles))]
        public async Task<HttpResponseMessage> GetUserRoles()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            var result = await RestHelper.ApiGet("roleScreenPermission/GetUserRoles");
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            return result;
        }
        [HttpGet("Fetch/{RoleId}/{ModuleId}")]
        public async Task<HttpResponseMessage> Fetch(int RoleId, int ModuleId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("roleScreenPermission/Fetch/{0}/{1}", RoleId, ModuleId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] RoleScreenPermissions roleScreenPermission)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("roleScreenPermission/Save", roleScreenPermission);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetModules/{UserTypeId}")]
        public async Task<HttpResponseMessage> GetModules(int UserTypeId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetModules), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("roleScreenPermission/GetModules/{0}", UserTypeId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetModules), Level.Info.ToString());
            return result;
        }
    }
}
