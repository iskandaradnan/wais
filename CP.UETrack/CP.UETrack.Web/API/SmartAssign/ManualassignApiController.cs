using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.UM
{
    [WebApiAuthentication]
    [RoutePrefix("api/Manualassign")]
    public class ManualassignApiController : BaseApiController
    {
        private readonly string _FileName = nameof(ManualassignApiController);
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());

            var filterData = GetQueryFiltersForGetAll();
            var PlannerType = GetPlannerType();
            var result = await RestHelper.ApiGet(string.Format("Manualassign/GetAll?{0}" + "&PlannerType" + "=" + PlannerType, filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("Manualassign/Load"));
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpPostAttribute("add")]
        public Task<HttpResponseMessage> Post(ManualassignViewModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("Manualassign/Add", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpPostAttribute("AddAssessment")]
        public Task<HttpResponseMessage> PostAssessment(ManualassignViewModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("Manualassign/AddAssessment", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpPostAttribute("AddTransfer")]
        public Task<HttpResponseMessage> PostTransfer(ManualassignViewModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("Manualassign/AddTransfer", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpPostAttribute("addCompletionInfo")]
        public Task<HttpResponseMessage> PostCompletionInfo(ManualassignViewModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("Manualassign/AddCompletionInfo", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpPostAttribute("AddPartReplacement")]
        public Task<HttpResponseMessage> PostPartReplacement(ManualassignViewModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("Manualassign/AddPartReplacement", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [HttpGet("Delete/{Id}")]
        public Task<HttpResponseMessage> Delete(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiDelete(string.Format("Manualassign/Delete/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("get/{id}")]
        public Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("GetAssessment/{id}")]
        public Task<HttpResponseMessage> GetAssessment(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/GetAssessment/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("getCompletionInfo/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetCompletionInfo(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/getCompletionInfo/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("GetPartReplacement/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetPartReplacement(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/GetPartReplacement/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("GetTransfer/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetTransfer(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/GetTransfer/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("GetReschedule/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetReschedule(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/GetReschedule/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("GetHistory/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetHistory(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/GetHistory/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("PartReplacementPopUp/{id}")]
        public Task<HttpResponseMessage> PartReplacementPopUp(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/PartReplacementPopUp/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("Popup/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> Popup(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/Popup/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("Summary/{Service}/{WorkGroup}/{Year}/{TOP}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> Summary(int Service, int WorkGroup, int Year, int TOP, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("Manualassign/Summary/{0}/{1}/{2}/{3}/{4}/{5}", Service, WorkGroup, Year, TOP, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        internal string GetPlannerType()
        {
            var PlannerType = Request.Headers.Referrer.AbsolutePath.Split('/')[2];
            return PlannerType;
        }
    }
}
