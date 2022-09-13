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

namespace UETrack.Application.Web.API.KPI
{
    [RoutePrefix("api/KPIDashboard")]
    [WebApiAudit]
    public class KPIDashboardAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(KPIDashboardAPIController);


        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("KPIDashboard/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Year}")]
        public async Task<HttpResponseMessage> Get(int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("KPIDashboard/Get/{0}", Year));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetDate/{Year}/{Month}")]
        public async Task<HttpResponseMessage> GetDate(int Year,int Month)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDate), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("KPIDashboard/GetDate/{0}/{1}", Year, Month));
            Log4NetLogger.LogEntry(_FileName, nameof(GetDate), Level.Info.ToString());
            return result;
        }
    }
}