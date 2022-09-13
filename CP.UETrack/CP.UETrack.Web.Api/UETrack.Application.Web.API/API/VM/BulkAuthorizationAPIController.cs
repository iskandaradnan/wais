using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.VM;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.VM
{
    [RoutePrefix("api/BulkAuthorization")]
    [WebApiAudit]
    public class BulkAuthorizationAPIController : BaseApiController
    { /// <summary>
      /// Standard Operating Procedures Web Api Class
      /// </summary>
        private readonly IBulkAuthorizationBAL _BulkAuthorizationBAL;
        private readonly ICommonBAL _commonBAL;
        private readonly string fileName = nameof(BulkAuthorizationAPIController);

        public BulkAuthorizationAPIController(IBulkAuthorizationBAL BulkAuthorizationBAL, ICommonBAL common)
        {
            _BulkAuthorizationBAL = BulkAuthorizationBAL;
            _commonBAL = common;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                var result = _BulkAuthorizationBAL.Load();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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
        [Route(nameof(Save))]
        public HttpResponseMessage Save(BulkAuthorizationViewModel BulkAuthorization)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;
                if (BulkAuthorization == null)
                {
                    return responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false);
                }
                if (!ModelState.IsValid)
                {
                    return BuildResponseObject(HttpStatusCode.BadRequest, false, ModelState);
                }

                //var userDetails = new UserDetailsModel();
                //userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId

                var BulkAuthorizationTxn = _BulkAuthorizationBAL.Save(BulkAuthorization, out ErrorMessage);
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    if (BulkAuthorizationTxn == null)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _BulkAuthorizationBAL.Get(BulkAuthorizationTxn.Year, BulkAuthorizationTxn.Month, BulkAuthorizationTxn.ServiceId,5,1);
                        responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData));
                    }

                }

                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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


        [HttpGet]
        [Route("get/{Year}/{Month}/{ServiceId}/{PageSize}/{PageIndex}")]
        public HttpResponseMessage Get(int Year, int Month, int ServiceId, int PageSize, int PageIndex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var assessment = _BulkAuthorizationBAL.Get(Year, Month, ServiceId, PageSize, PageIndex);
                var serialisedData = JsonConvert.SerializeObject(assessment);
                if (assessment == null)
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

    }
}
