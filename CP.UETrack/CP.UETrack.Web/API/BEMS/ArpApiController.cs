using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS;
using System.Reflection;

namespace UETrack.Application.Web.API.BEMS
{
    [RoutePrefix("api/Arp")]
    [WebApiAudit]
    public class ArpApiController :  BaseApiController
    {
        private readonly string _FileName = nameof(ArpApiController);
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("Arp/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] Arp arp)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Arp/Save", arp);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(ProposalSave))]
        public async Task<HttpResponseMessage> ProposalSave(HttpRequestMessage request, [FromBody] Arp arp)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ProposalSave), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Arp/ProposalSave", arp);
            Log4NetLogger.LogEntry(_FileName, nameof(ProposalSave), Level.Info.ToString());
            return result;
        }


        [HttpPost(nameof(Submit))]
        public async Task<HttpResponseMessage> Submit(HttpRequestMessage request, [FromBody] Arp arp)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Submit), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Arp/Submit", arp);
            Log4NetLogger.LogEntry(_FileName, nameof(Submit), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Get))]
        public async Task<HttpResponseMessage> Get(HttpRequestMessage request, [FromBody] Arp arp)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Arp/Get", arp);
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("Arpget/{id}")]
        public Task<HttpResponseMessage> ArpGet(int Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Arp/Arpget/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("Arp/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }
        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Arp/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Arp/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }


        [HttpGet("GetBERNoDetails/{Id}")]
        public async Task<HttpResponseMessage> GetBERNoDetails(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetBERNoDetails), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Arp/GetBERNoDetails/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(GetBERNoDetails), Level.Info.ToString());
            return result;
        }


        [HttpPost(nameof(GetWarrantyEndDate))]
        public async Task<HttpResponseMessage> GetWarrantyEndDate(HttpRequestMessage request, [FromBody] TAndCWarrnty tandCWarranty)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetWarrantyEndDate), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Arp/GetWarrantyEndDate", tandCWarranty);
            Log4NetLogger.LogEntry(_FileName, nameof(GetWarrantyEndDate), Level.Info.ToString());
            return result;
        }
    }
}
