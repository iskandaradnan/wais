using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.LLS;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

[WebApiAuthentication]
[RoutePrefix("api/CleanLinenRequest")]
public class CleanLinenRequestApiController : BaseApiController
{
    private readonly string _FileName = nameof(CleanLinenRequestApiController);
    [HttpGet(nameof(GetAll))]
    public async Task<HttpResponseMessage> GetAll()
    {
        Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        var filterData = GetQueryFiltersForGetAll();
        var result = await RestHelper.ApiGet(string.Format("CleanLinenRequest/GetAll?{0}", filterData));
        Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        return result;
    }

    //[HttpGet(nameof(Load))]
    //public async Task<HttpResponseMessage> Load()
    //{
    //    Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
    //    var result = await RestHelper.ApiGet("CleanLinenRequest/Load");
    //    Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
    //    return result;
    //}
    [HttpGet(nameof(Load))]
    public async Task<HttpResponseMessage> Load()
    {
        Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        var result = await RestHelper.ApiGet("CleanLinenRequest/Load");
        Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        return result;
    }


    [HttpPost(nameof(Save))]
    public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CleanLinenRequestModel model)
    {
        Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
        var result = await RestHelper.ApiPost("CleanLinenRequest/Save", model);
        Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
        return result;
    }

    [System.Web.Http.HttpPostAttribute("add")]
    public Task<HttpResponseMessage> Post(CleanLinenRequestModel model)
    {
        Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        var result = RestHelper.ApiPost("CleanLinenRequest/add", model);
        Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        return result;
    }

    //[HttpGet("Delete/{Id}")]
    //public Task<HttpResponseMessage> Delete(int Id)
    //{
    //    Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
    //    var result = RestHelper.ApiGet(string.Format("CleanLinenRequest/Delete/{0}", Id));
    //    Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
    //    return result;
    //}

    [HttpGet("Delete/{Id}")]
    public async Task<HttpResponseMessage> Delete(int Id)
    {
        Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        var result = await RestHelper.ApiGet(string.Format("CleanLinenRequest/Delete/{0}", Id));
        Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        return result;
    }

    [System.Web.Http.HttpGetAttribute("Get/{Id}")]
    public Task<HttpResponseMessage> Get(int Id)
    {
        Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        var result = RestHelper.ApiGet(string.Format("CleanLinenRequest/get/{0}", Id));
        Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        return result;
    }

}

