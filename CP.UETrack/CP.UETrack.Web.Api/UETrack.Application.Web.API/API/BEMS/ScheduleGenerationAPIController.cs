using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Configuration;
using System.Net.Http.Headers;
using System.Web;
using System.Text;
using CP.UETrack.Model.ICT;

namespace UETrack.Application.Web.API.API.BEMS
{
    [RoutePrefix("api/ScheduleGeneration")]
    [WebApiAudit]
    public class ScheduleGenerationAPIController : BaseApiController
    {
        private readonly IScheduleGenerationBAL _ScheduleGenerationBAL;
        private readonly ICommonBAL _commonBAL;
        private readonly string fileName = nameof(ScheduleGenerationAPIController);

        public ScheduleGenerationAPIController(IScheduleGenerationBAL bal, ICommonBAL common)
        {
            _ScheduleGenerationBAL = bal;
            _commonBAL = common;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _ScheduleGenerationBAL.Load();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;
        }


        [HttpPost]
        [Route("Add")]
        public HttpResponseMessage Post(ScheduleGenerationModel model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Post), Level.Info.ToString());
            try
            {
                var ErrorMessage = string.Empty;
                if (model == null)
                {
                    return responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false);
                }
                if (!ModelState.IsValid)
                {
                    return BuildResponseObject(HttpStatusCode.BadRequest, false, ModelState);
                }
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId
                var modelTxn = _ScheduleGenerationBAL.Save(model, out ErrorMessage);
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {

                    if (modelTxn == null || modelTxn.PpmScheduleId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _ScheduleGenerationBAL.Get(modelTxn.PpmScheduleId);
                        responseObject = (modelTxn != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }
                }
                Log4NetLogger.LogExit(fileName, nameof(Post), Level.Info.ToString());
            }
            catch (ValidationException ex)
            {
                responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false, ex);
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        /// <summary>
        /// Delete Standard Operating Procedures
        /// </summary>
        /// <param name="Id">Procedure Id</param>
        /// <returns>boolean</returns>
        [HttpDelete]
        [Route("Delete/{Id}")]
        public HttpResponseMessage Delete(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
                if (string.IsNullOrEmpty(Id))
                    return BuildResponseObject(HttpStatusCode.BadRequest);
                var primaryID = 0;
                if (int.TryParse(Id, out primaryID))
                {
                    var isSuccess = _ScheduleGenerationBAL.Delete(primaryID);

                    if (isSuccess)
                        responseObject = BuildResponseObject(HttpStatusCode.OK);
                    else
                        responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("DeleteFailed"));
                }
                else
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest);
                Log4NetLogger.LogExit(fileName, nameof(Delete), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        /// <summary>
        /// Get Standard Operating Procedures
        /// </summary>
        /// <param name="Id">Procedures Id</param>
        /// <returns>Standard Operating Procedures object</returns>
        [HttpGet]
        [Route("get/{id}")]
        public HttpResponseMessage Get(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _ScheduleGenerationBAL.Get(int.Parse(Id));
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;
        }

        [HttpGet]
        [Route("getby_year/{id}/{WorkGroup}/{week}/{serviceId}/{typeofplanner}")]
        public HttpResponseMessage getby_year(string Id,int WorkGroup, int week, int serviceId,int typeofplanner)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(getby_year), Level.Info.ToString());
                var obj = _ScheduleGenerationBAL.getby_year(int.Parse(Id),WorkGroup,week,serviceId,typeofplanner);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(getby_year), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;
        }

        [HttpGet]
        [Route("Fetch/{Service}/{WorkGroup}/{Year}/{TOP}/{StartDate}/{EndDate}/{WeekNo}/{Type}/{UserAreaId}/{UserLocationId}/{pagesize}/{pageindex}")]
        public HttpResponseMessage Fetch(int Service, int WorkGroup, int Year, string TOP, string StartDate, string EndDate, int WeekNo, string Type , string UserAreaId, string UserLocationId , int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _ScheduleGenerationBAL.Fetch(Service, WorkGroup, Year, TOP , StartDate , EndDate , WeekNo , Type , UserAreaId , UserLocationId , pagesize, pageindex);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;
        }


        [HttpGet]
        [Route("GetWeekNo/{Service}/{WorkGroup}/{Year}/{TOP}")]
        public HttpResponseMessage GetWeekNo(int Service, int WorkGroup, int Year, int TOP)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _ScheduleGenerationBAL.GetWeekNo(Service, WorkGroup, Year, TOP);
                var serialisedData = JsonConvert.SerializeObject(obj);
                if (obj == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;
        }



        [HttpPost]
        [Route("Print")]
        public HttpResponseMessage Print([FromBody] EngPpmScheduleGenTxnViewModel ppmsedule)
        {
            try
            {
                var PrintList = _ScheduleGenerationBAL.GetPrintList(ppmsedule);
                if (PrintList.Count > 0)
                {
                    var jsondat = new { Pprintlist = PrintList };
                    responseObject = BuildResponseObject(HttpStatusCode.OK, JsonConvert.SerializeObject(jsondat));
                }
                else
                {
                    var savelist = _ScheduleGenerationBAL.PrintPDF(ppmsedule);
                   
                    if (savelist != null && savelist.Count > 0)
                    {
                        var userDetails = new UserDetailsModel();
                        userDetails = GetUserDetails();
                        var CustomerId = userDetails.CustomerId;
                        var FacilityId = userDetails.FacilityId;
                        EngPpmScheduleGenPrint ppm = new EngPpmScheduleGenPrint();
                        ppm.CustomerId = CustomerId;
                        ppm.FacilityId = FacilityId;
                        ppm.CreatedBy = userDetails.UserId;
                        ppm.ModuleId = userDetails.UserDB;

                        ppm.TypeOfPlanner = Convert.ToInt32(ppmsedule.TypeOfPlanner);
                        ppm.Year = Convert.ToInt32(ppmsedule.Year);
                        ppm.WeekNo = Convert.ToInt32(ppmsedule.WeekNoGenerated);
                        ppm.WorkGroupId = Convert.ToInt32(ppmsedule.WorkGroupId);
                        ppm.EngUserAreaId = Convert.ToInt32(ppmsedule.EngUserAreaId);
                        ppm.WeekLogId = Convert.ToInt32(ppmsedule.WeekLogId);
                        savelist.ForEach(x => x.ModuleId = userDetails.UserDB);
                        ppm.Englist = savelist;
                        ppm.Description = ppmsedule.JobDescription + " - " + Convert.ToString(ppmsedule.Year) + " / " + Convert.ToString(ppmsedule.WeekNoGenerated);
                        var restult = RestHelperPPM.ApiPost("Home/Print", ppm);
                        ppmsedule.PrintActionType = "Print";
                        //var list = _ScheduleGenerationBAL.GetPrintList(ppmsedule);
                        //if (list != null && list.Count > 0)
                        //{
                        //    var jsondat = new { Pprintlist = list };
                        //    responseObject = BuildResponseObject(HttpStatusCode.OK, JsonConvert.SerializeObject(jsondat));
                        //}
                        //else
                        //{
                        //    responseObject = BuildResponseObject(HttpStatusCode.OK, "Please Wait PDF Generation is Processing");
                        //}

                        responseObject = BuildResponseObject(HttpStatusCode.OK, "InProgress...0% Completed");
                    }
                    else
                    {
                      
                     
                        responseObject = BuildResponseObject(HttpStatusCode.NotFound, "WorkOrder NotFound & " + ppmsedule.WeekLogId);
                    }
                }
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;

        }




        [HttpPost]
        [Route("PrintRefresh")]
        public HttpResponseMessage PrintRefresh([FromBody] EngPpmScheduleGenTxnViewModel ppmsedule)
        {
            try
            {
            
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails();
                ppmsedule.CreatedBy = userDetails.UserId;
                ppmsedule.ServiceId = ppmsedule.ServiceId;

                var list = _ScheduleGenerationBAL.GetPrintList(ppmsedule);
                if (list != null && list.Count > 0)
                {
                    var jsondat = new { Pprintlist = list };
                    responseObject = BuildResponseObject(HttpStatusCode.OK, JsonConvert.SerializeObject(jsondat));
                }
                //else
                //{
                //    responseObject = BuildResponseObject(HttpStatusCode.OK, "Please Wait PDF Generation is Processing");
                //}


            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;

        }

    }

    public static class RestHelperPPM
    {
        public static async Task<HttpResponseMessage> ApiPost(string url, dynamic data)
        {
            try
            {
                string baseUri = ConfigurationManager.AppSettings["FileServerInternalApiBaseUrl"];
               
                var jsonContentType = new MediaTypeWithQualityHeaderValue(@"application/json");
                var ts = new TimeSpan(0, 2, 0);

                using (HttpClient clientPost = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts })
                {
                    clientPost.DefaultRequestHeaders.Accept.Add(jsonContentType);
                    var IsUserAlreadyLoggedIn = false;
                    var request = HttpContext.Current.Request;
                    var bodyData = JsonConvert.SerializeObject(data);
                    using (var stringContent = new StringContent(bodyData, Encoding.UTF8, @"application/json"))
                    {
                       
                        var response = clientPost.PostAsync(url, stringContent);

                      

                        return response.Result;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return new HttpResponseMessage(System.Net.HttpStatusCode.ProxyAuthenticationRequired);
             
        }
    }
}
