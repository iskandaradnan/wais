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
    [RoutePrefix("api/TypeCode")]
    public class TypeCodeDetailsAPIController : BaseApiController
    {
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("TypeCode/GetAll?{0}", filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute(nameof(Load))]
        public Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("TypeCode/Load"));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpPostAttribute("add")]
        public Task<HttpResponseMessage> Post(EngAssetTypeCode obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("TypeCode/add", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public Task<HttpResponseMessage> Delete(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("TypeCode/Delete/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("get/{id}")]
        public Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("TypeCode/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("getSpecification/{id}")]
        public Task<HttpResponseMessage> GetSpecification(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("TypeCode/getSpecification/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
       
    }
}
