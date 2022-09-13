using UETrack.Application.Web.Helpers;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.Framework.Common.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;

namespace UETrack.Application.Web.API.Common
{
    [RoutePrefix("api/ReportFilter")]
    public class ReportFilterApiController : BaseApiController
    {
        public ReportFilterApiController()
        {
        }

        [HttpGet("GetReportParameters/{spName}")]
        public Task<HttpResponseMessage> GetReportParameters(string spName, string reportKeyId)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ReportFilter/GetReportParameters/{0}/{1}", spName, reportKeyId));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
    }
}
