using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.UM
{
    [RoutePrefix("api/NotificationDeliveryConfiguration")]
    [WebApiAudit]
    public class NotificationDeliveryConfigurationApiController : BaseApiController
    {
        private readonly string _FileName = nameof(NotificationDeliveryConfigurationApiController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("NotificationDeliveryConfiguration/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(NotificationDeliveryConfigurationModel Notification)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("NotificationDeliveryConfiguration/Save", Notification);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("NotificationDeliveryConfiguration/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("NotificationDeliveryConfiguration/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetRole/{Id}")]
        public async Task<HttpResponseMessage> GetRole(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetRole), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("NotificationDeliveryConfiguration/GetRole/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetRole), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetCompany/{Id}")]
        public async Task<HttpResponseMessage> GetCompany(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetCompany), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("NotificationDeliveryConfiguration/GetCompany/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetCompany), Level.Info.ToString());
            return result;
        }

        [HttpGet("GetLocation/{Id}")]
        public async Task<HttpResponseMessage> GetLocation(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetLocation), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("NotificationDeliveryConfiguration/GetLocation/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetLocation), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("NotificationDeliveryConfiguration/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
    }
}