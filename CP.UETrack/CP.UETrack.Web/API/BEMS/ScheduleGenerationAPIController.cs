using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.Filter;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.ICT;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{
    [WebApiAuthentication]
    [RoutePrefix("api/ScheduleGeneration")]
    public class ScheduleGenerationAPIController : BaseApiController
    {
       
        [System.Web.Http.HttpGetAttribute(nameof(Load))]
        public Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduleGeneration/Load"));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpPostAttribute("add")]
        public Task<HttpResponseMessage> Post(EngPlannerTxn obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduleGeneration/Add", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public Task<HttpResponseMessage> Delete(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiDelete(string.Format("ScheduleGeneration/Delete/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("get/{id}")]
        public Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduleGeneration/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute("getby_year/{id}/{WorkGroup}/{week}/{serviceId}/{typeofplanner}")]
        public Task<HttpResponseMessage> getby_year(string Id,int WorkGroup,int week,int serviceId,int typeofplanner)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduleGeneration/getby_year/{0}/{1}/{2}/{3}/{4}", Id, WorkGroup, week, serviceId, typeofplanner));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        //[System.Web.Http.HttpGetAttribute("Fetch/{Service}/{WorkGroup}/{Year}/{TOP}/{StartDate}/{EndDate}/{WeekNo}/{Type}/{pagesize}/{pageindex}")]
        //public Task<HttpResponseMessage> Fetch(int Service, int WorkGroup, int Year, int TOP, string StartDate , string EndDate, int WeekNo ,string Type , int pagesize, int pageindex)
        //{
        //    Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        //    var result = RestHelper.ApiGet(string.Format("ScheduleGeneration/Fetch/{0}/{1}/{2}/{3}/{4}/{5}/{6}/{7}/{8}/{9}", Service, WorkGroup, Year, TOP, StartDate , EndDate , WeekNo , Type , pagesize, pageindex));
        //    Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
        //    return result;
        //}

        [System.Web.Http.HttpGetAttribute("Fetch/{Service}/{WorkGroup}/{Year}/{TOP}/{StartDate}/{EndDate}/{WeekNo}/{Type}/{UserAreaId}/{UserLocationId}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> Fetch(int Service, int WorkGroup, int Year, string TOP, string StartDate, string EndDate, int WeekNo, string Type, string UserAreaId , string UserLocationId, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduleGeneration/Fetch/{0}/{1}/{2}/{3}/{4}/{5}/{6}/{7}/{8}/{9}/{10}/{11}", Service, WorkGroup, Year, TOP, StartDate, EndDate, WeekNo, Type, UserAreaId , UserLocationId , pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("GetWeekNo/{Service}/{WorkGroup}/{Year}/{TOP}")]
        public Task<HttpResponseMessage> GetWeekNo(int Service, int WorkGroup, int Year, int TOP)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduleGeneration/GetWeekNo/{0}/{1}/{2}/{3}", Service, WorkGroup, Year, TOP));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("Print")]        public Task<HttpResponseMessage> Print(EngPpmScheduleGenTxnViewModel obj)        {            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());            obj.WebRootPath = System.Web.Hosting.HostingEnvironment.MapPath("~/Attachments");            var result = RestHelper.ApiPost("ScheduleGeneration/Print", obj);            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());            return result;        }        [System.Web.Http.HttpPostAttribute("PrintRefresh")]        public Task<HttpResponseMessage> PrintRefresh(EngPpmScheduleGenTxnViewModel ppmsedule)        {            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());            ppmsedule.WebRootPath = System.Web.Hosting.HostingEnvironment.MapPath("~/Attachments");            var result = RestHelper.ApiPost("ScheduleGeneration/PrintRefresh", ppmsedule);            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());            return result;        }

        internal string GetPlannerType()
        {
            var PlannerType = Request.Headers.Referrer.AbsolutePath.Split('/')[2];
            return PlannerType;
        }
    }
}
