using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/additionalFields")]
    [WebApiAudit]
    public class AdditionalFieldsAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(AdditionalFieldsAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("additionalFields/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet("LoadAdditionalInfo/{ScreenId}")]
        public async Task<HttpResponseMessage> LoadAdditionalInfo(int ScreenId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAdditionalInfo), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("additionalFields/LoadAdditionalInfo/{0}", ScreenId));
            Log4NetLogger.LogEntry(_FileName, nameof(LoadAdditionalInfo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] AdditionalFieldsConfig AdditionalFieldsConfig)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("additionalFields/Save", AdditionalFieldsConfig);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("additionalFields/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{CustomerId}/{ScreenId}")]
        public async Task<HttpResponseMessage> Get(int CustomerId, int ScreenId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("additionalFields/Get/{0}/{1}", CustomerId, ScreenId));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("additionalFields/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetAdditionalInfoForAsset/{AssetId}")]
        public async Task<HttpResponseMessage> GetAdditionalInfoForAsset(int AssetId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForAsset), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("additionalFields/GetAdditionalInfoForAsset/{0}", AssetId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForAsset), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveAdditionalInfoForAsset))]
        public async Task<HttpResponseMessage> SaveAdditionalInfoForAsset(AssetRegisterAdditionalFields AdditionalInfo)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoForAsset), Level.Info.ToString());
            var result = await RestHelper.ApiPost("additionalFields/SaveAdditionalInfoForAsset", AdditionalInfo);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoForAsset), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetAdditionalInfoForTAndC/{TestingandCommissioningId}")]
        public async Task<HttpResponseMessage> GetAdditionalInfoForTAndC(int TestingandCommissioningId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForTAndC), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("additionalFields/GetAdditionalInfoForTAndC/{0}", TestingandCommissioningId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForTAndC), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveAdditionalInfoTAndC))]
        public async Task<HttpResponseMessage> SaveAdditionalInfoTAndC(TestingAndCommissioningAdditionalFields AdditionalInfo)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoTAndC), Level.Info.ToString());
            var result = await RestHelper.ApiPost("additionalFields/SaveAdditionalInfoTAndC", AdditionalInfo);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoTAndC), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetAdditionalInfoForWorkorder/{WorkOrderId}")]
        public async Task<HttpResponseMessage> GetAdditionalInfoForWorkorder(int WorkOrderId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForWorkorder), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("additionalFields/GetAdditionalInfoForWorkorder/{0}", WorkOrderId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForWorkorder), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveAdditionalInfoWorkorder))]
        public async Task<HttpResponseMessage> SaveAdditionalInfoWorkorder(workorderAdditionalFields AdditionalInfo)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoWorkorder), Level.Info.ToString());
            var result = await RestHelper.ApiPost("additionalFields/SaveAdditionalInfoWorkorder", AdditionalInfo);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoWorkorder), Level.Info.ToString());
            return result;
        }
    }
}
