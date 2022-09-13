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
    [RoutePrefix("api/ScheduledWorkOrder")]
    public class ScheduledWorkOrderAPIController : BaseApiController
    {
        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            
            var filterData = GetQueryFiltersForGetAll();
            var PlannerType = GetPlannerType();
            var result = await RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetAll?{0}" + "&PlannerType"+"="+PlannerType,filterData));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }
        [System.Web.Http.HttpGetAttribute(nameof(Load))]
        public Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/Load"));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("add")]
        public Task<HttpResponseMessage> Post(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/Add", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("AddReschedule")]
        public Task<HttpResponseMessage> PostReschedule(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/AddReschedule", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("AddAssessment")]
        public Task<HttpResponseMessage> PostAssessment(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/AddAssessment", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("AddTransfer")]
        public Task<HttpResponseMessage> PostTransfer(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/AddTransfer", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpPostAttribute("addCompletionInfo")]
        public Task<HttpResponseMessage> PostCompletionInfo(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/AddCompletionInfo", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpPostAttribute("AddPurchaseRequest")]
        public Task<HttpResponseMessage> PostPurchaseRequest(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/AddPurchaseRequest", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("AddPartReplacement")]
        public Task<HttpResponseMessage> PostPartReplacement(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/AddPartReplacement", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("AddPPMCheckList")]
        public Task<HttpResponseMessage> PostPPMCheckList(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/AddPPMCheckList", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("Delete/{Id}")]
        public Task<HttpResponseMessage> Delete(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiDelete(string.Format("ScheduledWorkOrder/Delete/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [HttpGet("ApproveReject/{Id}/{Remarks}/{Type}")]
        public Task<HttpResponseMessage> ApproveReject(string Id, string Remarks, string Type)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiDelete(string.Format("ScheduledWorkOrder/ApproveReject/{0}/{1}/{2}", Id, Remarks, Type));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("get/{id}")]
        public Task<HttpResponseMessage> Get(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/get/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("getQC/{id}")]
        public Task<HttpResponseMessage> GetQC(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/getQC/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("getCC/{id}")]
        public Task<HttpResponseMessage> GetCC(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/getCC/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("getCheckListDD/{id}")]
        public Task<HttpResponseMessage> GetCheckListDD(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetCheckListDD/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("GetAssessment/{id}")]
        public Task<HttpResponseMessage> GetAssessment(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetAssessment/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("getCompletionInfo/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetCompletionInfo(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/getCompletionInfo/{0}/{1}/{2}", Id,pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("GetPartReplacement/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetPartReplacement(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetPartReplacement/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("GetPurchaseRequest/{id}")]
        public Task<HttpResponseMessage> GetPurchaseRequest(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetPurchaseRequest/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("GetPPMCheckList/{id}/{CheckListId}")]
        public Task<HttpResponseMessage> GetPPMCheckList(string Id , string CheckListId)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetPPMCheckList/{0}/{1}", Id , CheckListId));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("GetTransfer/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetTransfer(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetTransfer/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpPostAttribute("CalculateResponse")]
        public Task<HttpResponseMessage> CalculateResponse(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/CalculateResponse", obj);
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("GetReschedule/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetReschedule(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetReschedule/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("GetHistory/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> GetHistory(string Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/GetHistory/{0}/{1}/{2}", Id, pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("FeedbackPopUp/{id}")]
        public Task<HttpResponseMessage> FeedbackPopUp(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/FeedbackPopUp/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }


        [System.Web.Http.HttpGetAttribute("PartReplacementPopUp/{id}")]
        public Task<HttpResponseMessage> PartReplacementPopUp(string Id)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/PartReplacementPopUp/{0}", Id));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("Popup/{id}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> Popup(string Id,int pagesize , int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/Popup/{0}/{1}/{2}", Id , pagesize , pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpGetAttribute("Summary/{Service}/{WorkGroup}/{Year}/{TOP}/{pagesize}/{pageindex}")]
        public Task<HttpResponseMessage> Summary(int Service , int WorkGroup, int Year, int TOP, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiGet(string.Format("ScheduledWorkOrder/Summary/{0}/{1}/{2}/{3}/{4}/{5}", Service , WorkGroup , Year , TOP , pagesize, pageindex));
            Log4NetLogger.LogExit(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            return result;
        }

        [System.Web.Http.HttpPostAttribute("VendorAssessProcess")]
        public Task<HttpResponseMessage> VendorAssessProcess(ScheduledWorkOrderModel obj)
        {
            Log4NetLogger.LogEntry(GetType().Name, MethodBase.GetCurrentMethod().Name, Level.Info.ToString());
            var result = RestHelper.ApiPost("ScheduledWorkOrder/VendorAssessProcess", obj);
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
