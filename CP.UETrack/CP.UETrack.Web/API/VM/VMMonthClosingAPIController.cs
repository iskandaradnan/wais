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
    [RoutePrefix("api/VMMonthClosingAPI")]
    [WebApiAudit]
    public class VMMonthClosingAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(VMMonthClosingAPIController);
        [HttpPost("MonthClose")]
        public async Task<HttpResponseMessage> save([FromBody] VMMonthClosingEntity level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("VMMonthClosingAPI/MonthClose", level);
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            return result;
        }
        [HttpGet("Load")]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("VMMonthClosingAPI/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost("Get")]
        public async Task<HttpResponseMessage> Get([FromBody] FetchMonthClosingDetails level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiPost("VMMonthClosingAPI/Get", level);
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("getall")]
        public async Task<HttpResponseMessage> Getall()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();

            var result = await RestHelper.ApiGet(string.Format("VMMonthClosingAPI/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            return result;
        }
    }
}
