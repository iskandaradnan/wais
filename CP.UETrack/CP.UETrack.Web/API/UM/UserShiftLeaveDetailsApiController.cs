using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.UM
{
    [RoutePrefix("api/UserShiftLeave")]
    [WebApiAudit]
    public class UserShiftLeaveDetailsApiController : BaseApiController
    {
        private readonly string _FileName = nameof(UserShiftLeaveDetailsApiController);

        public UserShiftLeaveDetailsApiController()
        {

        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("UserShiftLeave/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("UserShiftLeave/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("UserShiftLeave/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetLeaveDetails/{Id}")]
        public async Task<HttpResponseMessage> GetLeaveDetails(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetLeaveDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("UserShiftLeave/GetLeaveDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetLeaveDetails), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(UserShiftLeaveViewModel UserShiftLeave)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("UserShiftLeave/Save", UserShiftLeave);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }
    }
}

