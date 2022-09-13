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

namespace UETrack.Application.Web.API.LLS
{
    [WebApiAuthentication]
    [RoutePrefix("api/Department")]
    public class DepartmentAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(DepartmentAPIController);
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("Department/GetAll?{0}", filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("Department/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

       
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] DepartmentDetailsModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Department/Save", model);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("add")]
        public Task<HttpResponseMessage> Post(DepartmentDetailsModel model)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("Department/add", model);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(CheckUserAreaCode))]
        public async Task<HttpResponseMessage> CheckUserAreaCode(HttpRequestMessage request, [FromBody] DepartmentDetailsModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CheckUserAreaCode), Level.Info.ToString());
            var result = await RestHelper.ApiGet("Department/CheckUserAreaCode");
            Log4NetLogger.LogEntry(_FileName, nameof(CheckUserAreaCode), Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("CheckUserAreaCode/{Id}")]
        public Task<HttpResponseMessage> CheckUserAreaCode(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Department/CheckUserAreaCode/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        //[HttpGet("Delete/{Id}")]
        //public Task<HttpResponseMessage> Delete(int Id)
        //{
        //    Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        //    var result = RestHelper.ApiGet(string.Format("Department/Delete/{0}", Id));
        //    Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        //    return result;
        //}

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Department/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("Get/{Id}")]
        public Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Department/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenItemSave))]
        public async Task<HttpResponseMessage> LinenItemSave(HttpRequestMessage request, [FromBody] DepartmentDetailsModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LinenItemSave), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Department/LinenItemSave", model);
            Log4NetLogger.LogEntry(_FileName, nameof(LinenItemSave), Level.Info.ToString());
            return result;
        }
    }
}
