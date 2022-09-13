using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model.BEMS;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [WebApiAuthentication]
    [RoutePrefix("api/PPMPlanner")]
    public class PPMPlannerAPIController : BaseApiController
    {
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            
            var filterData = GetQueryFiltersForGetAll();
            var PlannerType = GetPlannerType();
            var result = await RestHelper.ApiGet(string.Format("PPMPlanner/GetAll?{0}"+"&PlannerType"+"="+PlannerType,filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute(nameof(Load))]
        public Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("PPMPlanner/Load"));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpPostAttribute("add")]
        public Task<HttpResponseMessage> Post(EngPlannerTxn obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("PPMPlanner/Add", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public Task<HttpResponseMessage> Delete(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiDelete(string.Format("PPMPlanner/Delete/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("get/{id}")]
        public Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("PPMPlanner/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("AssetFrequencyTaskCode/{id}")]
        public Task<HttpResponseMessage> AssetFrequencyTaskCode(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("PPMPlanner/AssetFrequencyTaskCode/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("AssetTypeCodeFrequency/{id}")]
        public Task<HttpResponseMessage> AssetTypeCodeFrequency(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("PPMPlanner/AssetTypeCodeFrequency/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("Popup/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> Popup(string Id,int pagesize , int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("PPMPlanner/Popup/{0}/{1}/{2}", Id , pagesize , pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("Summary/{Service}/{WorkGroup}/{Year}/{TOP}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> Summary(int Service , int WorkGroup, int Year, int TOP, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("PPMPlanner/Summary/{0}/{1}/{2}/{3}/{4}/{5}", Service , WorkGroup , Year , TOP , pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpPostAttribute("Upload")]
        public Task<HttpResponseMessage> Upload(PlannerUpload obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("PPMPlanner/Upload", obj);
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
