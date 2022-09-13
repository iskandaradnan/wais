using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.VM
{
    [RoutePrefix("api/VVFApi")]
    [WebApiAudit]
    public class VVFApiController : BaseApiController
    {
        private readonly string _FileName = nameof(VVFApiController);
        [HttpGet("Load")]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("VVFApi/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost("Get")]
        public async Task<HttpResponseMessage> Get([FromBody] VVFDetails level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiPost("VVFApi/Get", level);
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpPost("Update")]
        public async Task<HttpResponseMessage> Update([FromBody] VVFEntity level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Update), Level.Info.ToString());
            var result = await RestHelper.ApiPost("VVFApi/Update", level);
            if (result.StatusCode == HttpStatusCode.OK)
            {
                FileUploadHelper.FileUploadCreate(level.FileUploadList);
                
            }
            
            Log4NetLogger.LogEntry(_FileName, nameof(Update), Level.Info.ToString());
            return result;
        }
    }
}
