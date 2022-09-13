using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using System;

namespace UETrack.Application.Web.API.UM
{

    [RoutePrefix("api/smartAssigning")]
    [WebApiAudit]
    public class SmartAssignApiController : BaseApiController
    {
        private readonly string _FileName = nameof(SmartAssignApiController);
        public SmartAssignApiController()
        {

        }
        [HttpGet(nameof(RunSmartAssign))]
        public async Task<HttpResponseMessage> RunSmartAssign()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(RunSmartAssign), Level.Info.ToString());         
            var result = await RestHelper.ApiGet(string.Format("SmartAssign/RunSmartAssign"));
            Log4NetLogger.LogEntry(_FileName, nameof(RunSmartAssign), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(SmartAssignGetAll))]
        public async Task<HttpResponseMessage> SmartAssignGetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SmartAssignGetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();         
            var result = await RestHelper.ApiGet(string.Format("SmartAssign/SmartAssignGetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(SmartAssignGetAll), Level.Info.ToString());
            return result;
        }
    }
}
