using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.DAL.DataAccess.Implementation;
using System.Collections.Generic;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/unblockUser")]
    [WebApiAudit]
    public class UnblockUserApiController : BaseApiController
    {
        IUnblockUserBAL _IUnblockUserBALBAL;
        private readonly string _FileName = nameof(UnblockUserApiController);
        public UnblockUserApiController(IUnblockUserBAL unblockUserBALBAL)
        {
            _IUnblockUserBALBAL = unblockUserBALBAL;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _IUnblockUserBALBAL.Load();
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
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
        public HttpResponseMessage Save(UMUserRegistration userRegistration)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _IUnblockUserBALBAL.Save(userRegistration.UserRegistrationId, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                   
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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
        [Route(nameof(GetAll))]
        public HttpResponseMessage GetAll()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());

                SortPaginateFilter paginationFilter = null;
                
                paginationFilter = GridHelper.GetAllFormatSearchCondition<UMUserRegistration>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                
                var result = _IUnblockUserBALBAL.GetAll(paginationFilter);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var jsonData = new
                    {
                        total = result.TotalPages,
                        result.CurrentPage,
                        records = result.TotalRecords,
                        rows = result.RecordsList
                    };
                    responseObject = BuildResponseObject(HttpStatusCode.OK, jsonData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
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
        [Route("Get/{Id}")]
        public HttpResponseMessage Get(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _IUnblockUserBALBAL.Get(Id);

                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        [Route("Delete/{Id}")]
        public HttpResponseMessage Delete(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _IUnblockUserBALBAL.Delete(Id);
                responseObject = BuildResponseObject(HttpStatusCode.OK, string.Empty);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
        [Route("GetUserRoles/{Id}")]
        public HttpResponseMessage GetUserRoles(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                var result = _IUnblockUserBALBAL.GetUserRoles(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetUserRoles), Level.Info.ToString());
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
        [Route("GetLocations/{Id}")]
        public HttpResponseMessage GetLocations(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetLocations), Level.Info.ToString());
                var result = _IUnblockUserBALBAL.GetLocations(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetLocations), Level.Info.ToString());
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
        [Route(nameof(BlockingList))]
        public HttpResponseMessage BlockingList(string IdList)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BlockingList), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _IUnblockUserBALBAL.BlockingList(IdList);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);

                }
                Log4NetLogger.LogExit(_FileName, nameof(BlockingList), Level.Info.ToString());
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
