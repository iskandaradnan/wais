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
    [RoutePrefix("api/AssertregisterAssetProcessingStatus")]
    [WebApiAudit]
    public class AssertregisterAssetProcessingStatusController : ApiController
    {

        private readonly string _FileName = nameof(AssertregisterVariationDetailsTabApiController);
        [HttpPost("AssetProcessingStatus")]
        
        public async Task<HttpResponseMessage> FetchSNFRef([FromBody] AssetProcessingStatus level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
            var result = await RestHelper.ApiPost("AssertregisterAssetProcessingStatus/AssetProcessingStatus", level);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
            return result;
        }
    }
}
