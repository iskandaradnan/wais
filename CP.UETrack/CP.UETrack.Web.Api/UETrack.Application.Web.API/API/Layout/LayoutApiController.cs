using CP.UETrack.Application.Web.API;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.Model.Layout;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/layout")]
    [WebApiAudit]
    public class LayoutApiController : BaseApiController
    {
        ILayoutBAL _LayoutBAL;
        private readonly string _FileName = nameof(LayoutApiController);
        public LayoutApiController(ILayoutBAL layoutBAL)
        {
            _LayoutBAL = layoutBAL;
        }

        [HttpGet]
        [Route(nameof(GetCustomerAndFacilities))]
        public HttpResponseMessage GetCustomerAndFacilities()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
                var result = _LayoutBAL.GetCustomerAndFacilities();
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    //var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, result);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpGet]
        [Route("GetFacilities/{CustomerId}")]
        public HttpResponseMessage GetFacilities(int CustomerId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetFacilities), Level.Info.ToString());
                var result = _LayoutBAL.GetFacilities(CustomerId);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    //var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, result);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetFacilities), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }



        [HttpGet]
        [Route("GetNotificationCount/{FacilityId}/{UserId}")]
        public HttpResponseMessage GetNotificationCount(int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetNotificationCount), Level.Info.ToString());
                var result = _LayoutBAL.GetNotificationCount(FacilityId, UserId);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    //var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, result);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetNotificationCount), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpGet]
        [Route("GetNotification/{pagesize}/{pageindex}")]
        public HttpResponseMessage GetNotification(int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetNotification), Level.Info.ToString());
                var result = _LayoutBAL.GetNotification(pagesize, pageindex);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetNotification), Level.Info.ToString());
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
        [Route(nameof(ReseteNotificationCount))]
        public HttpResponseMessage ReseteNotificationCount(Notification notifi)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _LayoutBAL.ReseteNotificationCount(notifi);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    //result = _LayoutBAL.ReseteNotificationCount(result.CRMRequestWOId);
                    //responseObject = BuildResponseObject(HttpStatusCode.OK, JsonConvert.SerializeObject(result));
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
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
        [Route(nameof(ClearNavigatedRec))]
        public HttpResponseMessage ClearNavigatedRec(Notification notifi)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ClearNavigatedRec), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _LayoutBAL.ClearNavigatedRec(notifi);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    //result = _LayoutBAL.ReseteNotificationCount(result.CRMRequestWOId);
                    //responseObject = BuildResponseObject(HttpStatusCode.OK, JsonConvert.SerializeObject(result));
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(ClearNavigatedRec), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        [HttpGet]
        [Route(nameof(LoadCustomer))]
        public HttpResponseMessage LoadCustomer()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadCustomer), Level.Info.ToString());
                var result = _LayoutBAL.LoadCustomer();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadCustomer), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpGet]
        [Route("LoadFacility/{CusId}")]
        public HttpResponseMessage LoadFacility(int CusId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadFacility), Level.Info.ToString());
                var result = _LayoutBAL.LoadFacility(CusId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(LoadFacility), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpGet]
        [Route("GetCustomerFacilityDet/{CusId}/{FacId}")]
        public HttpResponseMessage GetCustomerFacilityDet(int CusId, int FacId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerFacilityDet), Level.Info.ToString());
                var result = _LayoutBAL.GetCustomerFacilityDet(CusId, FacId);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    //var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, result);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetCustomerFacilityDet), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
    }
}
