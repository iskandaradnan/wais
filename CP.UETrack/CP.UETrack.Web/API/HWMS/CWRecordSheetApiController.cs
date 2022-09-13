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
    [RoutePrefix("api/CWRecordSheet")]
    [WebApiAudit]
    public class CWRecordSheetApiController:BaseApiController
    {
        private readonly string _FileName = nameof(CWRecordSheetApiController);
      
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("CWRecordSheet/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CWRecordSheet CWRSheet)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CWRecordSheet/Save", CWRSheet);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
             
        [HttpGet("CollectionDetailsFetch/{Id}")]
        public async Task<HttpResponseMessage> CollectionDetailsFetch(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CollectionDetailsFetch), Level.Info.ToString());
            
            var result = await RestHelper.ApiGet(string.Format("CWRecordSheet/CollectionDetailsFetch/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(CollectionDetailsFetch), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CWRecordSheet/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CWRecordSheet/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        ////[HttpGet("CollectionTimeDetails/{CollectionTime}")]
        //[HttpGet(nameof(CollectionTimeDetails))]
        //public async Task<HttpResponseMessage> CollectionTimeDetails()
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(CollectionTimeDetails), Level.Info.ToString());
        //    var filterData = GetQueryFiltersForGetAll();
        //    var result = await RestHelper.ApiGet(string.Format("CWRecordSheet/CollectionTimeDetails/{0}", filterData));
        //    Log4NetLogger.LogEntry(_FileName, nameof(CollectionTimeDetails), Level.Info.ToString());
        //    return result;
        //}
        [HttpPost(nameof(CollectionTimeDetails))]
        public async Task<HttpResponseMessage> CollectionTimeDetails(HttpRequestMessage request, [FromBody] CWRecordSheetCollectionDetails CWRSheet)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CWRecordSheet/CollectionTimeDetails", CWRSheet);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
    }
}