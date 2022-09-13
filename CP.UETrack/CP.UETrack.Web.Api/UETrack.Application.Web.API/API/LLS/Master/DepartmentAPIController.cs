using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using CP.UETrack.Models.BEMS;
using FluentValidation;
using Newtonsoft.Json;
using System;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Contracts;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Master;

namespace UETrack.Application.Web.API.API.LLS
{

    [RoutePrefix("api/Department")]
    [WebApiAudit]

    public class DepartmentAPIController : BaseApiController
    {

        private readonly IDepartmentDetailsBAL  _DepartmentDetailsBAL;
        private readonly string fileName = nameof(DepartmentAPIController);


        public DepartmentAPIController(IDepartmentDetailsBAL DepartmentDetailsBAL)
        {
            _DepartmentDetailsBAL = DepartmentDetailsBAL;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _DepartmentDetailsBAL.Load();
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
        [Route(nameof(Save))]
        public HttpResponseMessage Save(DepartmentDetailsModel model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                // if you are updating ..u no need to check this
                var result = _DepartmentDetailsBAL.Save(model, out ErrorMessage);
               
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    result.LLSUserAreaId = model.UserAreaID;
                    if (result == null || result.LLSUserAreaId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _DepartmentDetailsBAL.Get(result.LLSUserAreaId);

                        responseObject = (result != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }

                }
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


        //[HttpPost]
        //[Route(nameof(CheckUserAreaCode))]
        //public HttpResponseMessage CheckUserAreaCode(DepartmentDetailsModel model)
        //{
        //    try
        //    {
        //        var ErrorMessage = string.Empty;
        //        // if you are updating ..u no need to check this
        //        var result = _DepartmentDetailsBAL.CheckUserAreaCode(model, out ErrorMessage);

        //        if (ErrorMessage != string.Empty)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
        //        }
        //        else
        //        {
        //            result.LLSUserAreaId = model.UserAreaID;
        //            if (result == null || result.LLSUserAreaId == 0)
        //                BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
        //            else
        //            {
        //                var ResultData = _DepartmentDetailsBAL.Get(result.LLSUserAreaId);

        //                responseObject = (result != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

        //            }

        //        }
        //        Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}

        [HttpGet]
        [Route("CheckUserAreaCode/{Id}")]
        public HttpResponseMessage CheckUserAreaCode(string Id)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(CheckUserAreaCode), Level.Info.ToString());
                var result = _DepartmentDetailsBAL.CheckUserAreaCode(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(CheckUserAreaCode), Level.Info.ToString());
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
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _DepartmentDetailsBAL.Get(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());

                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<DepartmentDetailsModel>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var result = _DepartmentDetailsBAL.GetAll(paginationFilter);
                if (result == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                {
                    var jsonData = new
                    {
                        total = result.TotalPages,
                        result.CurrentPage,
                        records = result.TotalRecords,
                        rows = result.RecordsList
                    };
                    responseObject = jsonData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, jsonData);
                }
                Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
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
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                _DepartmentDetailsBAL.Delete(Id, out ErrorMessage);
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.OK, "Success");
                }
                Log4NetLogger.LogExit(fileName, nameof(Delete), Level.Info.ToString());
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
        [Route(nameof(LinenItemSave))]
        public HttpResponseMessage LinenItemSave(DepartmentDetailsModel model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                // if you are updating ..u no need to check this
                var result = _DepartmentDetailsBAL.LinenItemSave(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {

                    if (result == null || result.LLSUserAreaId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _DepartmentDetailsBAL.Get(result.LLSUserAreaId);

                        responseObject = (result != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

                    }

                }
                Log4NetLogger.LogExit(fileName, nameof(LinenItemSave), Level.Info.ToString());
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