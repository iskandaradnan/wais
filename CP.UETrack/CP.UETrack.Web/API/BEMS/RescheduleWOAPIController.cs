using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model.BEMS;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [WebApiAuthentication]
    [RoutePrefix("api/RescheduleWO")]
    public class RescheduleWOAPIController : BaseApiController
    {
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = await RestHelper.ApiGet("RescheduleWO/Load");
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("RescheduleWO/GetAll?{0}", filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
     


        [System.Web.Http.HttpPostAttribute("Save")]
        public Task<HttpResponseMessage> Post(RescheduleWOViewModel RescheduleWO)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("RescheduleWO/Save", RescheduleWO);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public Task<HttpResponseMessage> Delete(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiDelete(string.Format("RescheduleWO/Delete/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("get/{id}")]
        public Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("RescheduleWO/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(FetchWorkorder))]
        public Task<HttpResponseMessage> FetchWorkorder(RescheduleWOViewModel RescheduleWO)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("RescheduleWO/FetchWorkorder", RescheduleWO);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
    }
}
