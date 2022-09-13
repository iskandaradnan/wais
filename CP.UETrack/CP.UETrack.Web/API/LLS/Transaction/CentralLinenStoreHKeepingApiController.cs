using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.LLS;
using CP.UETrack.Application.Web.Filter;
using System.Reflection;

namespace UETrack.Application.Web.API.LLS.Transaction
{

    [WebApiAuthentication]
    [RoutePrefix("api/CentralLinenStoreHKeeping")]
    public class CentralLinenStoreHKeepingApiController : BaseApiController
    { 
      private readonly string _FileName = nameof(CentralLinenStoreHKeepingApiController);

    public CentralLinenStoreHKeepingApiController()
    {

    }

    [HttpGet(nameof(Load))]
    public async Task<HttpResponseMessage> Load()
    {
        Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        var result = await RestHelper.ApiGet("CentralLinenStoreHKeeping/Load");
        Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        return result;
    }

    [HttpPost(nameof(Save))]
    public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CentralLinenStoreHousekeepingModel model)
    {
        Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
        var result = await RestHelper.ApiPost("CentralLinenStoreHKeeping/Save", model);
        Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
        return result;
    }

    [HttpGet(nameof(GetAll))]
    public async Task<HttpResponseMessage> GetAll()
    {
        Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
        var filterData = GetQueryFiltersForGetAll();
        var result = await RestHelper.ApiGet(string.Format("CentralLinenStoreHKeeping/GetAll?{0}", filterData));
        Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
        return result;
    }

    [HttpGet("Get/{Id}")]
    public async Task<HttpResponseMessage> Get(int Id)
    {
        Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        var result = await RestHelper.ApiGet(string.Format("CentralLinenStoreHKeeping/Get/{0}", Id));
        Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        return result;
    }

        [System.Web.Http.HttpGetAttribute("HKeeping/{StoreType}/{Year}/{Month}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> HKeeping(int StoreType, int Year, int Month,int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("CentralLinenStoreHKeeping/HKeeping/{0}/{1}/{2}/{3}/{4}", StoreType, Year, Month, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
    public async Task<HttpResponseMessage> Delete(int Id)
    {
        Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        var result = await RestHelper.ApiGet(string.Format("CentralLinenStoreHKeeping/Delete/{0}", Id));
        Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        return result;
    }
}
}
