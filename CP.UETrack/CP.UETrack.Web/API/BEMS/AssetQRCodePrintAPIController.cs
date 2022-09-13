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
    [RoutePrefix("api/AssetQRCode")]
    [WebApiAudit]
    public class AssetQRCodePrintAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(AssetQRCodePrintAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("AssetQRCode/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(AssetQRCodePrintModel AssetQR)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("AssetQRCode/Save", AssetQR);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{AssetQR}")]
        public async Task<HttpResponseMessage> Get(AssetQRCodePrintModel AssetQR)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("AssetQRCode/Get/{0}", AssetQR));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        //[HttpGet("GetModal/{querycondition}/{pageindex}/{pagesize}")]
        //public async Task<HttpResponseMessage> GetModal(string querycondition,int pageindex, int pagesize)
        //{

        //    Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
        //    var map=querycondition[0];
        //    var result = await RestHelper.ApiGet(string.Format("AssetQRCode/GetModal/{0}/{1}/{2}", querycondition, pageindex, pagesize));
        //    Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
        //    return result;
        //}

        [HttpPost(nameof(GetModal))]
        public async Task<HttpResponseMessage> GetModal(AssetQRCodePrintModel AssetQR)
        {

            Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());            
            var result = await RestHelper.ApiPost("AssetQRCode/GetModal", AssetQR);
            Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
            return result;
        }


        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("AssetQRCode/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("AssetQRCode/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
    }
}