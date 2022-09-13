using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS.CRMWorkOrder;
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
    [RoutePrefix("api/CRMWorkorderTab")]
    [WebApiAudit]
    public class CRMWorkorderApiController : BaseApiController
    {
        private readonly string _FileName = nameof(CRMWorkorderApiController);

        public CRMWorkorderApiController()
        {

        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("CRMWorkorderTab/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CRMWorkorder EODCap)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CRMWorkorderTab/Save", EODCap);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CRMWorkorderTab/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMWorkorderTab/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMWorkorderTab/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveAssessment))]
        public async Task<HttpResponseMessage> SaveAssessment(HttpRequestMessage request, [FromBody] CRMWorkorderAssessment ass)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAssessment), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CRMWorkorderTab/SaveAssessment", ass);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAssessment), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetAssessment/{Id}")]
        public async Task<HttpResponseMessage> GetAssessment(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssessment), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMWorkorderTab/GetAssessment/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssessment), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveCompInfo))]
        public async Task<HttpResponseMessage> SaveCompInfo(HttpRequestMessage request, [FromBody] CRMWorkorderCompInfo Compinfo)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveCompInfo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CRMWorkorderTab/SaveCompInfo", Compinfo);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveCompInfo), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetCompInfo/{Id}")]
        public async Task<HttpResponseMessage> GetCompInfo(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetCompInfo), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMWorkorderTab/GetCompInfo/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetCompInfo), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetProcessStatus/{Id}")]
        public async Task<HttpResponseMessage> GetProcessStatus(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetProcessStatus), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CRMWorkorderTab/GetProcessStatus/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetProcessStatus), Level.Info.ToString());
            return result;
        }
    }
}