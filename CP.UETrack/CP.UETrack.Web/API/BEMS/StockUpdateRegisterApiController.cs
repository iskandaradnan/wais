using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/StockUpdateRegisterApi")]
    [WebApiAudit]
    public class StockUpdateRegisterApiController : BaseApiController
    {

        private readonly string _FileName = nameof(StockUpdateRegisterApiController);
        [HttpPost("save")]
        public async Task<HttpResponseMessage> save([FromBody] StockUpdateRegister level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("StockUpdateRegisterApi/save", level);
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            return result;
        }
        [HttpPost("update")]
        public async Task<HttpResponseMessage> update([FromBody] StockUpdateRegister level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
            var result = await RestHelper.ApiPost("StockUpdateRegisterApi/update", level);
            Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{id}/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> Get(int id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("StockUpdateRegisterApi/Get/{0}/{1}/{2}", id, pagesize,pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Getall")]
        public async Task<HttpResponseMessage> Getall()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();

            var result = await RestHelper.ApiGet(string.Format("StockUpdateRegisterApi/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{id}")]
        public async Task<HttpResponseMessage> Delete(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("StockUpdateRegisterApi/Delete/{0}", id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
        [HttpGet("Load")]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("StockUpdateRegisterApi/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost("Upload")]
        public async Task<HttpResponseMessage> Upload([FromBody] Upload level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Upload), Level.Info.ToString());
            var result = await RestHelper.ApiPost("StockUpdateRegisterApi/Upload", level);
            Log4NetLogger.LogEntry(_FileName, nameof(Upload), Level.Info.ToString());
            return result;
        }
    }
}
