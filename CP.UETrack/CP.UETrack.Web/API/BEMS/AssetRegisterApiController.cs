using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS.AssetRegister;
using System.Net;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/assetRegister")]
    [WebApiAudit]
    public class AssetRegisterApiController : BaseApiController
    {
        private readonly string _FileName = nameof(AssetRegisterApiController);
       
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("assetRegister/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] AssetRegisterModel assetRegister)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("assetRegister/Save", assetRegister);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("assetRegister/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetTestingAndCommissioningDetails/{Id}")]
        public async Task<HttpResponseMessage> GetTestingAndCommissioningDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetTestingAndCommissioningDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetTestingAndCommissioningDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetTestingAndCommissioningDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("assetRegister/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetChildAsset/{Id}")]
        public async Task<HttpResponseMessage> GetChildAsset(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetChildAsset/{0}?{1}", Id, filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetAssetStatusDetails/{AssetId}")]
        public async Task<HttpResponseMessage> GetAssetStatusDetails(int AssetId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssetStatusDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetAssetStatusDetails/{0}", AssetId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssetStatusDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetAssetRealTimeStatusDetails/{AssetId}")]
        public async Task<HttpResponseMessage> GetAssetRealTimeStatusDetails(int AssetId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssetRealTimeStatusDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetAssetRealTimeStatusDetails/{0}", AssetId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssetRealTimeStatusDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetSoftwareDetails/{AssetId}")]
        public async Task<HttpResponseMessage> GetSoftwareDetails(int AssetId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetSoftwareDetails/{0}", AssetId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetDefectDetails/{AssetId}")]
        public async Task<HttpResponseMessage> GetDefectDetails(int AssetId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDefectDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetDefectDetails/{0}", AssetId));
            Log4NetLogger.LogEntry(_FileName, nameof(GetDefectDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetAccessoriesGridData/{Id}/{PageSize}/{PageIndex}")]
        public async Task<HttpResponseMessage> GetChildAsset(int Id, int PageSize, int PageIndex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetAccessoriesGridData/{0}/{1}/{2}", Id, PageSize, PageIndex));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveAccessoriesGridData))]
        public async Task<HttpResponseMessage> SaveAccessoriesGridData(HttpRequestMessage request, [FromBody] AssetRegisterAccessoriesMstModel assetRegister)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAccessoriesGridData), Level.Info.ToString());
            assetRegister.AssetRegisterAccessoriesDetModel = FileUploadHelper.FileUploadAccessories(assetRegister.AssetRegisterAccessoriesDetModel);
            var result = await RestHelper.ApiPost("assetRegister/SaveAccessoriesGridData", assetRegister);
            if (result.StatusCode == HttpStatusCode.OK)
            {
                FileUploadHelper.FileUploadCreateAccessories(assetRegister.AssetRegisterAccessoriesDetModel);
            }
            Log4NetLogger.LogEntry(_FileName, nameof(SaveAccessoriesGridData), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetContractorVendor/{Id}")]
        public async Task<HttpResponseMessage> GetContractorVendor(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetContractorVendor/{0}?{1}", Id, filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("GetAssetSpecification/{Id}")]
        public async Task<HttpResponseMessage> GetAssetSpecification(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssetSpecification), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("assetRegister/GetAssetSpecification/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssetSpecification), Level.Info.ToString());
            return result;
        }
        [HttpPost("Upload")]
        public async Task<HttpResponseMessage> Upload([FromBody] AssetRegisterUpload level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Upload), Level.Info.ToString());
            var result = await RestHelper.ApiPost("assetRegister/Upload", level);
            Log4NetLogger.LogEntry(_FileName, nameof(Upload), Level.Info.ToString());
            return result;
        }
    }
}
