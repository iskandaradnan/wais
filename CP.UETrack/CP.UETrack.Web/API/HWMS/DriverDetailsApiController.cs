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
    [RoutePrefix("api/HWMSDriverDetails")]
    [WebApiAudit]
    public class HWMSDriverDetailsApiController : BaseApiController
    {

        private readonly string _FileName = nameof(HWMSDriverDetailsApiController);

        public HWMSDriverDetailsApiController()
        {


        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("HWMSDriverDetails/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] DriverDetails driverDetails)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("HWMSDriverDetails/Save", driverDetails);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("HWMSDriverDetails/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HWMSDriverDetails/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
               

        [HttpGet("DescriptionData/{LicenseCode}")]
        public async Task<HttpResponseMessage> DescriptionData(string LicenseCode)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DescriptionData), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("HWMSDriverDetails/DescriptionData/{0}", LicenseCode));
            Log4NetLogger.LogEntry(_FileName, nameof(DescriptionData), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LicenseCodeFetch))]
        public async Task<HttpResponseMessage> LicenseCodeFetch(HttpRequestMessage request, [FromBody] LicCodeDes SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("HWMSDriverDetails/LicenseCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
            return result;
        }


    }
}