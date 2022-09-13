using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BER
{
    [RoutePrefix("api/BERDashboard")]
    [WebApiAudit]
    public class BERDashboardAPIController : BaseApiController
    {
        // GET: BERDashboardAPI
        private readonly string _FileName = nameof(BERDashboardAPIController);

        public BERDashboardAPIController()
        {

        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("BERDashboard/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }


        [HttpGet("LoadGrid/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> LoadGrid(int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadGrid), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("BERDashboard/LoadGrid/{0}/{1}", pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadGrid), Level.Info.ToString());
            return result;
        }
    }
}