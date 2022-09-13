using UETrack.Application.Web.Helpers;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.HWMS;

namespace UETrack.Application.Web.API.HWMS
{

    [RoutePrefix("api/HWMSLicenseType")]
    [WebApiAudit]
    public class HWMSLicenseTypeApiController : BaseApiController
    {
        private readonly string _FileName = nameof(HWMSLicenseTypeApiController);

        public HWMSLicenseTypeApiController()
        {

        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] LicenseType licenseType)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("HWMSLicenseType/Save", licenseType);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("HWMSLicenseType/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HWMSLicenseType/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HWMSLicenseType/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(AutoDisplaying))]
        public async Task<HttpResponseMessage> AutoDisplaying()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("HWMSLicenseType/AutoDisplaying?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("HWMSLicenseType/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
    }
}
