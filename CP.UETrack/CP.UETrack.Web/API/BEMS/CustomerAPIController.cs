using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model;
using CP.UETrack.Models.BEMS;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [WebApiAuthentication]
    [RoutePrefix("api/Customer")]
    public class CustomerAPIController : BaseApiController
    {
        private readonly string fileName = nameof(CustomerAPIController);

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("Customer/GetAll?{0}", filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpPostAttribute("add")]
        public Task<HttpResponseMessage> Post(CustomerMstViewModel cust)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("Customer/add", cust);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute(nameof(Load))]
        public Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Customer/Load"));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Customer/Delete/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("get/{id}")]
        public Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Customer/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("getFacilityList/{id}")]
        public Task<HttpResponseMessage> GetFacilityList(int Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Customer/GetFacilityList/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveReportsAndRecords))]
        public async Task<HttpResponseMessage> SaveReportsAndRecords(HttpRequestMessage request, [FromBody] ReportsAndRecordsList ReportsAndRecords)
        {
            Log4NetLogger.LogEntry(fileName, nameof(SaveReportsAndRecords), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Customer/SaveReportsAndRecords", ReportsAndRecords);
            Log4NetLogger.LogEntry(fileName, nameof(SaveReportsAndRecords), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetReportsAndRecords/{CustomerId}")]
        public async Task<HttpResponseMessage> GetReportsAndRecords(int CustomerId)
        {
            Log4NetLogger.LogEntry(fileName, nameof(GetReportsAndRecords), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Customer/GetReportsAndRecords/{0}", CustomerId));
            Log4NetLogger.LogEntry(fileName, nameof(GetReportsAndRecords), Level.Info.ToString());
            return result;
        }
    }
}
