using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;

namespace UETrack.Application.Web.API.VM
{
    [RoutePrefix("api/SummaryofFeeReportAPI")]
    [WebApiAudit]
    public class SummaryofFeeReportAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(VMMonthClosingAPIController);
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        [HttpPost("Save")]
        public async Task<HttpResponseMessage> save([FromBody] SFRSaveEntity level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("SummaryofFeeReportAPI/Save", level);
            Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
            return result;
        }
        [HttpGet("Load")]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("SummaryofFeeReportAPI/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost("GetDetails")]
        public async Task<HttpResponseMessage> GetDetails(FetchDetails level)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDetails), Level.Info.ToString());
            var result = await RestHelper.ApiPost("SummaryofFeeReportAPI/GetDetails", level);
            Log4NetLogger.LogEntry(_FileName, nameof(GetDetails), Level.Info.ToString());
            return result;
        }
        [HttpGet("getall")]
        public async Task<HttpResponseMessage> Getall()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();

            var result = await RestHelper.ApiGet(string.Format("SummaryofFeeReportAPI/GetAll/?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("SummaryofFeeReportAPI/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
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
            var result = await RestHelper.ApiGet(string.Format("SummaryofFeeReportAPI/ChangeService/{0}", ServiceId));
            Log4NetLogger.LogEntry(_FileName, nameof(ChangeService), Level.Info.ToString());
            return result;
        }

    }
}
