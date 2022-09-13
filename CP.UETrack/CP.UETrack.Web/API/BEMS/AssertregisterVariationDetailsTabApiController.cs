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
    [RoutePrefix("api/AssertregisterVariationDetailsTab")]
    [WebApiAudit]
    public class AssertregisterVariationDetailsTabApiController : ApiController
    {

        private readonly string _FileName = nameof(AssertregisterVariationDetailsTabApiController);
        [HttpPost("FetchSNFRef")]
        public async Task<HttpResponseMessage> FetchSNFRef([FromBody] Varabledetails level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
            var result = await RestHelper.ApiPost("AssertregisterVariationDetailsTab/FetchSNFRef", level);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(FetchSNFRef1))]
        public async Task<HttpResponseMessage> FetchSNFRef1([FromBody] Varabledetails level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef1), Level.Info.ToString());
            var result = await RestHelper.ApiPost("AssertregisterVariationDetailsTab/FetchSNFRef1", level);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef1), Level.Info.ToString());
            return result;
        }

        [HttpPost("Save")]
        public async Task<HttpResponseMessage> Save([FromBody] VariationSaveEntity level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
            var result = await RestHelper.ApiPost("AssertregisterVariationDetailsTab/Save", level);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
            return result;
        }
    }
}
