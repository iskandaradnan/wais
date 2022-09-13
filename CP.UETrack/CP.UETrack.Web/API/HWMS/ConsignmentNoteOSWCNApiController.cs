using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.HWMS
{
    [RoutePrefix("api/ConsignmentNoteOSWCN")]
    [WebApiAudit]
    public class ConsignmentNoteOSWCNApiController: BaseApiController
    {
        private readonly string _FileName = nameof(ConsignmentNoteOSWCNApiController);
        public ConsignmentNoteOSWCNApiController()
        {
        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("ConsignmentNoteOSWCN/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
       
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] ConsignmentNoteOSWCN OSWCN)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("ConsignmentNoteOSWCN/Save", OSWCN);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteOSWCN/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteOSWCN/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(AttachmentSave))]
        public async Task<HttpResponseMessage> AttachmentSave(HttpRequestMessage request, [FromBody] ConsignmentNoteOSWCN consignmentNoteOSWCNAttachment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
            var result = await RestHelper.ApiPost("ConsignmentNoteOSWCN/AttachmentSave", consignmentNoteOSWCNAttachment);
            Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
            return result;
        }
        [HttpGet("WasteTypeData/{Wastetype}")]
        public async Task<HttpResponseMessage> WasteTypeData(string Wastetype)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(WasteTypeData), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteOSWCN/WasteTypeData/{0}", Wastetype));
            Log4NetLogger.LogEntry(_FileName, nameof(WasteTypeData), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(FetchConsign))]
        public async Task<HttpResponseMessage> FetchConsign(HttpRequestMessage request, [FromBody] ConsignmentNoteOSWCN consignmentNote)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchConsign), Level.Info.ToString());
            var result = await RestHelper.ApiPost("ConsignmentNoteOSWCN/FetchConsign", consignmentNote);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchConsign), Level.Info.ToString());
            return result;
           
        }
       
    }
}