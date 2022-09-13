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

namespace UETrack.Application.Web.API.QAP
{
    [RoutePrefix("api/QAPDashboard")]
    [WebApiAudit]
    public class QAPDashboardAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(QAPDashboardAPIController);


        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("QAPDashboard/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Year}")]
        public async Task<HttpResponseMessage> Get(int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("QAPDashboard/Get/{0}", Year));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetLineChart/{Month}")]
        public async Task<HttpResponseMessage> GetLineChart(int Month)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetLineChart), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("QAPDashboard/GetLineChart/{0}", Month));
            Log4NetLogger.LogEntry(_FileName, nameof(GetLineChart), Level.Info.ToString());
            return result;
        }
    }
}