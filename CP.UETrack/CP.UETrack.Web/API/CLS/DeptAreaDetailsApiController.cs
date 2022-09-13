using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.Controllers
{
    [RoutePrefix("api/DeptAreaDetails")]
    [WebApiAudit]
    public class DeptAreaDetailsApiController : BaseApiController
    {
        private readonly string _FileName = nameof(DeptAreaDetailsApiController);

        public DeptAreaDetailsApiController()
        {
        }

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("DeptAreaDetails/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] DeptAreaDetails deptAreaDetails)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetails/Save", deptAreaDetails);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveRecp))]
        public async Task<HttpResponseMessage> SaveRecp(HttpRequestMessage request, [FromBody] Receptacles _receptacles)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveRecp), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetails/SaveRecp", _receptacles);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveRecp), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveDailyClean))]
        public async Task<HttpResponseMessage> SaveDailyClean(HttpRequestMessage request, [FromBody] DailyCleaningSchedule _dailyCleaning)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveDailyClean), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetails/SaveDailyClean", _dailyCleaning);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveDailyClean), Level.Info.ToString());
            return result;
        }


        [HttpPost(nameof(SavePeriodicWork))]
        public async Task<HttpResponseMessage> SavePeriodicWork(HttpRequestMessage request, [FromBody] PeriodicWorkSchedule _periodicWorkSchedule)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SavePeriodicWork), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetails/SavePeriodicWork", _periodicWorkSchedule);
            Log4NetLogger.LogEntry(_FileName, nameof(SavePeriodicWork), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveToilet))]
        public async Task<HttpResponseMessage> SaveToilet(HttpRequestMessage request, [FromBody] List<Toilet> _lsttoilet)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveToilet), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetails/SaveToilet", _lsttoilet);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveToilet), Level.Info.ToString());
            return result;
        }


        [HttpPost(nameof(SaveDispenser))]
        public async Task<HttpResponseMessage> SaveDispenser(HttpRequestMessage request, [FromBody] Dispenser _dispenser)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveDispenser), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetails/SaveDispenser", _dispenser);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveDispenser), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SaveVariationDetails))]
        public async Task<HttpResponseMessage> SaveVariationDetails(HttpRequestMessage request, [FromBody] List<VariationDetails> _lstVariationDetails)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveVariationDetails), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DeptAreaDetails/SaveVariationDetails", _lstVariationDetails);
            Log4NetLogger.LogEntry(_FileName, nameof(SaveVariationDetails), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("DeptAreaDetails/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("DeptAreaDetails/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(UserAreaCodeFetch))]
        public Task<HttpResponseMessage> UserAreaCodeFetch(DeptAreaDetails AD)
        {
            Log4NetLogger.LogEntry(GetType().Name, nameof(UserAreaCodeFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("DeptAreaDetails/UserAreaCodeFetch", AD);
            Log4NetLogger.LogExit(GetType().Name, nameof(UserAreaCodeFetch), Level.Info.ToString());
            return result;
        }


        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("DeptAreaDetails/Delete/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            return result;
        }
    }
}