using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.Framework.Common.StateManagement;


namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/correctiveActionReport")]
    [WebApiAudit]
    public class CorrectiveActionReportAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(CorrectiveActionReportAPIController);
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("correctiveActionReport/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] CorrectiveActionReport correctiveActionReport)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("correctiveActionReport/Save", correctiveActionReport);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("correctiveActionReport/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}/{PageIndex}/{PageSize}")]
        public async Task<HttpResponseMessage> Get(int Id, int PageIndex, int PageSize)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("correctiveActionReport/Get/{0}/{1}/{2}", Id, PageIndex, PageSize));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetWorkOrderDetails/{Id}")]
        public async Task<HttpResponseMessage> GetWorkOrderDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("correctiveActionReport/GetWorkOrderDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetCARHistoryDetails/{Id}")]
        public async Task<HttpResponseMessage> GetCARHistoryDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetCARHistoryDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("correctiveActionReport/GetCARHistoryDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetCARHistoryDetails), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveWorkOrderDetails))]
        public async Task<HttpResponseMessage> SaveWorkOrderDetails(CARWorkOrderList carWorkOrderList)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveWorkOrderDetails), Level.Info.ToString());
            var result = await RestHelper.ApiPost("correctiveActionReport/SaveWorkOrderDetails", carWorkOrderList);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveWorkOrderDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("correctiveActionReport/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetRootCauses/{Id}")]
        public async Task<HttpResponseMessage> GetRootCauses(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetRootCauses), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("correctiveActionReport/GetRootCauses/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetRootCauses), Level.Info.ToString());
            return result;
        }

        [HttpGet("ChangeService/{ServiceId}")]
        public async Task<HttpResponseMessage> ChangeService(int ServiceId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ChangeService), Level.Info.ToString());
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            if (ServiceId == 1)
            {
                userDetail.UserDB = 2;
            }
            else if (ServiceId == 2)
            {
                userDetail.UserDB = 1;
            }
            else
            {
                userDetail.UserDB = 0;
            }

            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            var result = await RestHelper.ApiGet(string.Format("correctiveActionReport/ChangeService/{0}", ServiceId));
            Log4NetLogger.LogEntry(_FileName, nameof(ChangeService), Level.Info.ToString());
            return result;
        }
    }
}
