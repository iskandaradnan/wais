using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS.AssetRegister;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/currentMaintenance")]
    [WebApiAudit]
    public class CurrentMaintenanceAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(AssetRegisterApiController);
       
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("currentMaintenance/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
       
    }
}
