using CP.Framework.Common.Audit;
using CP.UETrack.Application.Web.API;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Mvc;
using CP.Framework.Common.Logging;
using UETrack.Application.Web.Helpers;
using System.Web.Http;
using HttpGetAttribute = System.Web.Http.HttpGetAttribute;

namespace UETrack.Application.Web.API.FEMS
{
    [RoutePrefix("api/fems")]
    [WebApiAudit]
    public class FemsEncryptApicontroller : BaseApiController
    {
        private readonly string _FileName = nameof(FemsEncryptApicontroller);

        public FemsEncryptApicontroller()
        {

        }
        // GET: FemsEncrypt
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Fems/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
    }
}