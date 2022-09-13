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
    [RoutePrefix("api/CollectionCategory")]
    [WebApiAudit]
    public class CollectionCategoryApiController : BaseApiController
    {
        private readonly string _FileName = nameof(CollectionCategoryApiController);

        public CollectionCategoryApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("CollectionCategory/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CollectionCategory collectionCategory)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CollectionCategory/Save", collectionCategory);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("CollectionCategory/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CollectionCategory/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(UserAreaCodeFetch))]
        public async Task<HttpResponseMessage> UserAreaCodeFetch(HttpRequestMessage request, [FromBody] DeptAreaDetails SearchObject)
        {

            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("CollectionCategory/UserAreaCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
            return result;
        }

        [HttpGet("UserAreaNameData/{UserAreaCode}")]
        public async Task<HttpResponseMessage> UserAreaNameData(string UserAreaCode)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CollectionCategory/UserAreaNameData/{0}", UserAreaCode));
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("CollectionCategory/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }        
    }
}