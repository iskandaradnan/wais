using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.KPI;
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
    [RoutePrefix("api/MonthlyServiceFee")]
    [WebApiAudit]
    public class MonthlyServiceFeeAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(MonthlyServiceFeeAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("MonthlyServiceFee/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(MonthlyServiceFeeModel ServiceFee)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("MonthlyServiceFee/Save", ServiceFee);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("MonthlyServiceFee/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("MonthlyServiceFee/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("MonthlyServiceFee/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetRevision/{Id}/{Year}")]
        public async Task<HttpResponseMessage> GetRevision(int Id,int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetRevision), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("MonthlyServiceFee/GetRevision/{0}/{1}", Id,Year));
            Log4NetLogger.LogEntry(_FileName, nameof(GetRevision), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetVersion/{Year}")]
        public async Task<HttpResponseMessage> GetVersion(int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetVersion), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("MonthlyServiceFee/GetVersion/{0}", Year));
            Log4NetLogger.LogEntry(_FileName, nameof(GetVersion), Level.Info.ToString());
            return result;
        }

    }
}