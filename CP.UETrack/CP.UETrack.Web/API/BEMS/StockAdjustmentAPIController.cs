using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/StockAdjustment")]
    [WebApiAudit]
    public class StockAdjustmentAPIController: BaseApiController
    {
        private readonly string _FileName = nameof(StockAdjustmentAPIController);

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(StockAdjustmentModel Adjustment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("StockAdjustment/Save", Adjustment);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("StockAdjustment/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> Get(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("StockAdjustment/Get/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("StockAdjustment/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

    }
}