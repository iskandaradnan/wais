using CP.Framework.Common.Audit;
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

    [RoutePrefix("api/ConsignmentNoteCWCN")]
    [WebApiAudit]

    public class ConsignmentNoteCWCNApiController : BaseApiController
    {
        private readonly string _FileName = nameof(ConsignmentNoteCWCNApiController);

        public ConsignmentNoteCWCNApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("ConsignmentNoteCWCN/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(AutoDisplaying))]
        public async Task<HttpResponseMessage> AutoDisplaying()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteCWCN/AutoDisplaying?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] ConsignmentNoteCWCN consignmentNoteCWCN)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("ConsignmentNoteCWCN/Save", consignmentNoteCWCN);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteCWCN/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteCWCN/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(AttachmentSave))]
        public async Task<HttpResponseMessage> AttachmentSave(HttpRequestMessage request, [FromBody] ConsignmentNoteCWCN consignmentNoteCWCNAttachment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
            var result = await RestHelper.ApiPost("ConsignmentNoteCWCN/AttachmentSave", consignmentNoteCWCNAttachment);
            Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
            return result;
        }
      
        [HttpPost(nameof(VehicleNoFetch))]
        public async Task<HttpResponseMessage> VehicleNoFetch(HttpRequestMessage request, [FromBody] VehicleDetails SearchObject)
        {

            Log4NetLogger.LogEntry(_FileName, nameof(VehicleNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("ConsignmentNoteCWCN/VehicleNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(VehicleNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(DriverCodeFetch))]
        public async Task<HttpResponseMessage> DriverCodeFetch(HttpRequestMessage request, [FromBody] DriverDetails SearchObject)
        {

            Log4NetLogger.LogEntry(_FileName, nameof(DriverCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("ConsignmentNoteCWCN/DriverCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(DriverCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(AutoDisplayDWRSNO))]
        public async Task<HttpResponseMessage> AutoDisplayDWRSNO()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplayDWRSNO), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteCWCN/AutoDisplayDWRSNO?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplayDWRSNO), Level.Info.ToString());
            return result;
        }
         [HttpGet(nameof(DWRSNOData))]
       //[HttpGet("DWRSNOData/{DWRNo}")]
        public async Task<HttpResponseMessage> DWRSNOData(int DWRId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DWRSNOData), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteCWCN/DWRSNOData?DWRId={0}", DWRId));
            Log4NetLogger.LogEntry(_FileName, nameof(DWRSNOData), Level.Info.ToString());
            return result;
        }
        [HttpGet("TreatmentPlantData/{TreatmentPlantName}")]
        public async Task<HttpResponseMessage> TreatmentPlantData(string TreatmentPlantName)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(TreatmentPlantData), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("ConsignmentNoteCWCN/TreatmentPlantData/{0}", TreatmentPlantName));
            Log4NetLogger.LogEntry(_FileName, nameof(TreatmentPlantData), Level.Info.ToString());
            return result;
        }
     
    }
}