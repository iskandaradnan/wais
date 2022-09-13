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
    [RoutePrefix("api/BinMaster")]
    [WebApiAudit]
    public class BinMasterApiController : BaseApiController
    {
        // GET: BinMasterApi
        private readonly string _FileName = nameof(BinMasterApiController);

        public BinMasterApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("BinMaster/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        } 
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] BinMaster binMaster)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("BinMaster/Save", binMaster);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

       [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("BinMaster/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

       [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("BinMaster/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("BinMasterDelete/{ID}")]
        public async Task<HttpResponseMessage> BinMasterDelete(int ID)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BinMasterDelete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("BinMaster/BinMasterDelete/{0}", ID));
            Log4NetLogger.LogEntry(_FileName, nameof(BinMasterDelete), Level.Info.ToString());
            return result;
        }
    }
}