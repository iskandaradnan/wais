using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/WarrantyManagement")]
    [WebApiAudit]
    public class WarrantyManagementAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(WarrantyManagementAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("WarrantyManagement/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save([FromBody]WarrantyManagement WarrantyMan)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("WarrantyManagement/Save", WarrantyMan);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("WarrantyManagement/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("WarrantyManagement/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("WarrantyManagement/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }

        // Defect Details Tab
        [HttpGet("GetDD/{Id}/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> GetDD(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDD), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("WarrantyManagement/GetDD/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(GetDD), Level.Info.ToString());
            return result;
        }

        // Work Order Tab
        [HttpGet("GetWO/{Id}/{pagesize}/{pageindex}")]
        public async Task<HttpResponseMessage> GetWO(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetWO), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("WarrantyManagement/GetWO/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogEntry(_FileName, nameof(GetWO), Level.Info.ToString());
            return result;
        }
    }
}
