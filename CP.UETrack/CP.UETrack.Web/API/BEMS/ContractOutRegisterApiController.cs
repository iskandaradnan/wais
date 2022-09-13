using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
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
    [RoutePrefix("api/ContractOutRegisterApi")]
    [WebApiAudit]
    public class ContractOutRegisterApiController : BaseApiController
    {

        private readonly string _FileName = nameof(StockUpdateRegisterApiController);
        [HttpPost("save")]
        public async Task<HttpResponseMessage> save([FromBody] ContractOutRegisterEntity level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("ContractOutRegisterApi/save", level);
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            return result;
        }
        [HttpPost("update")]
        public async Task<HttpResponseMessage> update([FromBody] ContractOutRegisterEntity level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
            var result = await RestHelper.ApiPut("ContractOutRegisterApi/update", level);
            Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{id}/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> Get(int id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("ContractOutRegisterApi/Get/{0}/{1}/{2}", id, pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Getall")]
        public async Task<HttpResponseMessage> Getall()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();

            var result = await RestHelper.ApiGet(string.Format("ContractOutRegisterApi/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{id}")]
        public async Task<HttpResponseMessage> Delete(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("ContractOutRegisterApi/Delete/{0}", id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
        [HttpGet("Load")]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("ContractOutRegisterApi/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("GetPopupDetails/{primaryId}/{ContractHisId}")]
        public Task<HttpResponseMessage> GetPopupDetails(int primaryId, int ContractHisId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetPopupDetails), Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ContractOutRegisterApi/GetPopupDetails/{0}/{1}", primaryId, ContractHisId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetPopupDetails), Level.Info.ToString());
            return result;
        }
    }
}
