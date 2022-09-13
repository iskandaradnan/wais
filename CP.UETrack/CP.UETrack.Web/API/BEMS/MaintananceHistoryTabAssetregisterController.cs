using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/MaintananceHistoryTabAssetregisterController")]
    [WebApiAudit]
    public class MaintananceHistoryTabAssetregisterController : ApiController
    {

        private readonly string _FileName = nameof(AssertregisterVariationDetailsTabApiController);
        [HttpPost("fetchMaitenanceDetails")]
        public async Task<HttpResponseMessage> fetchMaitenanceDetails([FromBody] MaitenaceDetailsTab model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(fetchMaitenanceDetails), Level.Info.ToString());
            var result = await RestHelper.ApiPost("MaintananceHistoryTabAssetregisterController/fetchMaitenanceDetails", model);
            Log4NetLogger.LogEntry(_FileName, nameof(fetchMaitenanceDetails), Level.Info.ToString());
            return result;
        }
    }
}
