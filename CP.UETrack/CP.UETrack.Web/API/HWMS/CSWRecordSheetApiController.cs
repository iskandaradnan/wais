﻿using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using UETrack.Application.Web.Helpers;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.UETrack.Model.HWMS;
using UETrack.Application.Web.Controllers;

namespace UETrack.Application.Web.API.HWMS
{
    [RoutePrefix("api/CSWRecordSheet")]
    [WebApiAudit]

    public class CSWRecordSheetApiController : BaseApiController
    {
        private readonly string _FileName = nameof(CSWRecordSheetApiController);

        public CSWRecordSheetApiController()
        {
        }
        // GET: CSWRecordSheetApi
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("CSWRecordSheet/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(AutoGeneratedCode))]
        public async Task<HttpResponseMessage> AutoGeneratedCode()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CSWRecordSheet/AutoGeneratedCode?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CSWRecordSheet cswrecord)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CSWRecordSheet/Save", cswrecord);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CSWRecordSheet/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CSWRecordSheet/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(AutoDisplaying))]
        public async Task<HttpResponseMessage> AutoDisplaying()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CSWRecordSheet/AutoDisplaying?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
            return result;
        }       
        [HttpGet("WasteCodeGet/{WasteType}")]
        public async Task<HttpResponseMessage> WasteCodeGet(string WasteType)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CSWRecordSheet/WasteCodeGet/{0}", WasteType));
            Log4NetLogger.LogEntry(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CSWRecordSheet/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
        
    }
}