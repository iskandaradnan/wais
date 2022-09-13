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

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/userRegistration")]
    [WebApiAudit]
    public class UserRegistrationApiController : BaseApiController
    {
        IUserRegistrationBAL _UserRegistrationBAL;
        private readonly string _FileName = nameof(UserRegistrationApiController);
        public UserRegistrationApiController(IUserRegistrationBAL userRegistrationBAL)
        {
            _UserRegistrationBAL = userRegistrationBAL;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _UserRegistrationBAL.Load();
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

                if (userRegistration.UserRegistrationId == 0)
                {
                    var randomNUmber = new Random();
                    var password = userRegistration.UserName + randomNUmber.Next(-999, 0); ;
                    userRegistration.Password = CP.Framework.Security.Cryptography.CryptoProvider.CreateHashValue(password);
                }

                var ErrorMessage = string.Empty;
                var result = _UserRegistrationBAL.Save(userRegistration, out ErrorMessage);

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
                
                var result = _UserRegistrationBAL.GetAll(paginationFilter);
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
                var result = _UserRegistrationBAL.Get(Id);

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
                var ErrorMessage = string.Empty;
                _UserRegistrationBAL.Delete(Id, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.OK, "Success");
                }
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
                var result = _UserRegistrationBAL.GetUserRoles(Id);
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
                var result = _UserRegistrationBAL.GetLocations(Id);
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
        [Route(nameof(GetAllLocations))]
        public HttpResponseMessage GetAllLocations()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAllLocations), Level.Info.ToString());
                var result = _UserRegistrationBAL.GetAllLocations();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetAllLocations), Level.Info.ToString());
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
        [Route(nameof(GetStaffNames))]
        public HttpResponseMessage GetStaffNames()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetStaffNames), Level.Info.ToString());
                var result = _UserRegistrationBAL.GetStaffNames();
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetStaffNames), Level.Info.ToString());
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
