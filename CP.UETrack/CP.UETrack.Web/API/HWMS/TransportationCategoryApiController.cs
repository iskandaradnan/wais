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
    [RoutePrefix("api/TransportationCategory")]
    [WebApiAudit]
    public class TransportationCategoryApiController : BaseApiController
    {
        private readonly string _FileName = nameof(TransportationCategoryApiController);
        public TransportationCategoryApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("TransportationCategory/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] TransportationCategory transportationCategory)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("TransportationCategory/Save", transportationCategory);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("TransportationCategory/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("TransportationCategory/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(HospitalCodeFetch))]
        public async Task<HttpResponseMessage> HospitalCodeFetch(HttpRequestMessage request, [FromBody] TransportationCategoryTable SearchObject)
        {
            
            Log4NetLogger.LogEntry(_FileName, nameof(HospitalCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("TransportationCategory/HospitalCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(HospitalCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpGet("HospitalNameData/{HospitalCode}")]
        public async Task<HttpResponseMessage> HospitalNameData(string HospitalCode)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(HospitalNameData), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("TransportationCategory/HospitalNameData/{0}", HospitalCode));
            Log4NetLogger.LogEntry(_FileName, nameof(HospitalNameData), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("TransportationCategory/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
        [HttpGet("TransportationRowsDelete/{ID}")]
        public async Task<HttpResponseMessage> TransportationRowsDelete(int ID)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(TransportationRowsDelete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("TransportationCategory/TransportationRowsDelete/{0}", ID));
            Log4NetLogger.LogEntry(_FileName, nameof(TransportationRowsDelete), Level.Info.ToString());
            return result;
        }
    }
}