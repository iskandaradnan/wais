using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web;
using CP.UETrack.Model;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.Filter;
using UETrack.Application.Web.Helpers;
using System.Threading.Tasks;
using CP.UETrack.Application.Web.API;

namespace UETrack.Application.Web.API.CLS
{
    [RoutePrefix("Api/CLSFetch")]
    [WebApiAuthentication]
    public class CLSFetchAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(CLSFetchAPIController);
        // GET: CLSFetchAPI
       

        [HttpPost(nameof(LocationCodeFetch))]
        public async Task<HttpResponseMessage> LocationCodeFetch(HttpRequestMessage request, [FromBody] UserLocationCodeSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CLSFetch/LocationCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
            return result;
        }
    }
}