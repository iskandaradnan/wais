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
    [RoutePrefix("api/EODCapture")]
    [WebApiAudit]
    public class EODCaptureAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(EODCaptureAPIController);

        public EODCaptureAPIController()
        {

        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("EODCapture/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] EODCapture EODCap)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("EODCapture/Save", EODCap);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("EODCapture/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("EODCapture/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        //[HttpGet("BindDetGrid/{serviceId}/{CatSysId}/{Recdate}")]
        //public async Task<HttpResponseMessage> BindDetGrid(int serviceId, int CatSysId, DateTime Recdate)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    var result = await RestHelper.ApiGet(string.Format("EODCapture/BindDetGrid/{0}/{1}/{2}", serviceId, CatSysId, Recdate));
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    return result;
        //}

        [HttpPost(nameof(BindDetGrid))]
        public async Task<HttpResponseMessage> BindDetGrid(HttpRequestMessage request, [FromBody] EODCapture EODCap)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BindDetGrid), Level.Info.ToString());
            var result = await RestHelper.ApiPost("EODCapture/BindDetGrid", EODCap);
            Log4NetLogger.LogEntry(_FileName, nameof(BindDetGrid), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("EODCapture/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
    }
}
