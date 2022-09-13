using UETrack.Application.Web.Helpers;
using CP.UETrack.Model.HWMS;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;

namespace UETrack.Application.Web.API.HWMS
{
    [RoutePrefix("api/TreatmentPlant")]
    [WebApiAudit]
    public class TreatmentPlantApiController:BaseApiController
    {
        private readonly string _FileName = nameof(TreatmentPlantApiController);

        public TreatmentPlantApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("TreatmentPlant/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] TreatmetPlant TreatmetPlant)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("TreatmentPlant/Save", TreatmetPlant);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("TreatmentPlant/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpGet("VehicleDetailsFetch/{TreatmentPlantId}")]
        public async Task<HttpResponseMessage> VehicleDetailsFetch(int TreatmentPlantId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(VehicleDetailsFetch), Level.Info.ToString());           
            var result = await RestHelper.ApiGet("TreatmentPlant/VehicleDetailsFetch/" + TreatmentPlantId);
            Log4NetLogger.LogEntry(_FileName, nameof(VehicleDetailsFetch), Level.Info.ToString());
            return result;
        }
        [HttpGet("DriverDetailsFetch/{TreatmentPlantId}")]
        public async Task<HttpResponseMessage> DriverDetailsFetch(int TreatmentPlantId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DriverDetailsFetch), Level.Info.ToString());          
            var result = await RestHelper.ApiGet("TreatmentPlant/DriverDetailsFetch/" + TreatmentPlantId);
            Log4NetLogger.LogEntry(_FileName, nameof(DriverDetailsFetch), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("TreatmentPlant/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(LicenseCodeFetch))]
        public async Task<HttpResponseMessage> LicenseCodeFetch(HttpRequestMessage request, [FromBody] TreatmetPlantLicenseDetails SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("TreatmentPlant/LicenseCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
            return result;
        }
      
    }
}