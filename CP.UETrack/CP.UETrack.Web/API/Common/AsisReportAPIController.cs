using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.Common
{
    [RoutePrefix("api/AsisReport")]
    [WebApiAudit]
    public class AsisReportAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(AsisReportAPIController);

        

        [HttpPost(nameof(ExecuteDataSet))]
        public async Task<HttpResponseMessage> ExecuteDataSet(AsisReportViewModel rVM)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ExecuteDataSet), Level.Info.ToString());
            var result = await RestHelper.ApiPost("AsisReport/ExecuteDataSet", rVM);
            Log4NetLogger.LogEntry(_FileName, nameof(ExecuteDataSet), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetDataTableForDdl))]
        public async Task<HttpResponseMessage> GetDataTableForDdl(AsisReportViewModel rVM)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDataTableForDdl), Level.Info.ToString());
            var result = await RestHelper.ApiPost("AsisReport/GetDataTableForDdl", rVM);
            Log4NetLogger.LogEntry(_FileName, nameof(GetDataTableForDdl), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetSqlParmsList))]
        public async Task<HttpResponseMessage> GetSqlParmsList(AsisReportViewModel rVM)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetSqlParmsList), Level.Info.ToString());
            var result = await RestHelper.ApiPost("AsisReport/GetSqlParmsList", rVM);
            Log4NetLogger.LogEntry(_FileName, nameof(GetSqlParmsList), Level.Info.ToString());
            return result;
        }
    }
}
