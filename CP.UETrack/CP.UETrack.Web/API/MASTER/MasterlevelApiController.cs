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

    [RoutePrefix("api/masterlevel")]
    [WebApiAudit]
    public class MasterlevelApiController : BaseApiController
    {
        private readonly string _FileName = nameof(MasterlevelApiController);

        public MasterlevelApiController()
        {
            
        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Masterlevel/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] LevelMstViewModel level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Masterlevel/Save", level);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("Masterlevel/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Masterlevel/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Masterlevel/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetBlockData/{levelFacilityId}")]
        public async Task<HttpResponseMessage> GetBlockData(int levelFacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Masterlevel/GetBlockData/{0}", levelFacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
    }
}
