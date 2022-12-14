using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/DepartmentQRCode")]
    [WebApiAudit]
    public class DepartmentQRCodePrintingAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(DepartmentQRCodePrintingAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("DepartmentQRCode/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Get))]
        public async Task<HttpResponseMessage> Get(DepartmentQRCodePrintingModel DepartmentQR)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DepartmentQRCode/Get", DepartmentQR);
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetModal))]
        public async Task<HttpResponseMessage> GetModal(DepartmentQRCodePrintingModel DepartmentQR)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DepartmentQRCode/GetModal", DepartmentQR);
            Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(DepartmentQRCodePrintingModel DepartmentQR)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DepartmentQRCode/Save", DepartmentQR);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("DepartmentQRCode/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
    }
}