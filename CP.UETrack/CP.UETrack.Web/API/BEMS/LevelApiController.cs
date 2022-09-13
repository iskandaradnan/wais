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

    [RoutePrefix("api/Level")]
    [WebApiAudit]
    public class LevelApiController : BaseApiController
    {
        private readonly string _FileName = nameof(LevelApiController);

        public LevelApiController()
        {
            
        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Level/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] LevelMstViewModel level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Level/Save", level);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("Level/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Level/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Level/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetBlockData/{levelFacilityId}")]
        public async Task<HttpResponseMessage> GetBlockData(int levelFacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Level/GetBlockData/{0}", levelFacilityId));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        #region Master
        //[HttpGet(nameof(MasterLoad))]
        //public async Task<HttpResponseMessage> MasterLoad()
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        //    var result = await RestHelper.ApiGet(string.Format("Level/MasterLoad"));
        //    Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        //    return result;
        //}

        //[HttpPost(nameof(MasterSave))]
        //public async Task<HttpResponseMessage> MasterSave(HttpRequestMessage request, [FromBody] LevelMstViewModel level)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
        //    var result = await RestHelper.ApiPost("Level/MasterSave", level);
        //    Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
        //    return result;
        //}

        //[HttpGet(nameof(MasterGetAll))]
        //public async Task<HttpResponseMessage> MasterGetAll()
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
        //    var filterData = GetQueryFiltersForGetAll();
        //    var result = await RestHelper.ApiGet(string.Format("Level/MasterGetAll?{0}", filterData));
        //    Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
        //    return result;
        //}

        //[HttpGet("MasterGet/{Id}")]
        //public async Task<HttpResponseMessage> MasterGet(int Id)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    var result = await RestHelper.ApiGet(string.Format("Level/MasterGet/{0}", Id));
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    return result;
        //}
        //[HttpGet("MasterDelete/{Id}")]
        //public async Task<HttpResponseMessage> MasterDelete(int Id)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        //    var result = await RestHelper.ApiGet(string.Format("Level/MasterDelete/{0}", Id));
        //    Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        //    return result;
        //}

        //[HttpGet("MasterGetBlockData/{levelFacilityId}")]
        //public async Task<HttpResponseMessage> MasterGetBlockData(int levelFacilityId)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    var result = await RestHelper.ApiGet(string.Format("Level/MasterGetBlockData/{0}", levelFacilityId));
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    return result;
        //}
        #endregion


    }
}
