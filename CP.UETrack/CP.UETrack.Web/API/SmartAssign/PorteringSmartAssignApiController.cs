using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using System;

namespace UETrack.Application.Web.API.SmartAssign
{
    [RoutePrefix("api/PorteringSmartAssign")]
    [WebApiAudit]
    public class PorteringSmartAssignApiController : BaseApiController
    {
        private readonly string _FileName = nameof(PorteringSmartAssignApiController);
        public PorteringSmartAssignApiController()
        {

        }
        [HttpGet(nameof(PorteringSmartAssignGetAll))]
        public async Task<HttpResponseMessage> PorteringSmartAssignGetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(PorteringSmartAssignGetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("SmartAssign/PorteringSmartAssignGetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(PorteringSmartAssignGetAll), Level.Info.ToString());
            return result;
        }
    }
}
