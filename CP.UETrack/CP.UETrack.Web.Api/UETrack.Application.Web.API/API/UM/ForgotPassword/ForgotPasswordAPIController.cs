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
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Application.Web.API.Helpers;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/forgotPassword")]
    [WebApiAudit]
    public class ForgotPasswordAPIController : BaseApiController
    {
        IForgotPasswordBAL _ForgotPasswordBAL;
        private readonly string _FileName = nameof(ForgotPasswordAPIController);

        public ForgotPasswordAPIController(IForgotPasswordBAL forgotPasswordBAL)
        {
            _ForgotPasswordBAL = forgotPasswordBAL;
        }

        //[HttpGet]
        //[Route(nameof(Load))]
        //public HttpResponseMessage Load()
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        //        var result = _ForgotPasswordBAL.Load();
        //        if (result == null)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
        //        }
        //        else
        //        {
        //            var serialisedData = JsonConvert.SerializeObject(result);
        //            responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
        //        }

        //        Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}

        [HttpPost]
        [Route(nameof(Save))]
        public HttpResponseMessage Save(ForgotPassword forgotPassword)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _ForgotPasswordBAL.Save(forgotPassword, out ErrorMessage);

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

        //[HttpGet]
        //[Route(nameof(GetAll))]
        //public HttpResponseMessage GetAll()
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());

        //        SortPaginateFilter paginationFilter = null;

        //        paginationFilter = GridHelper.GetAllFormatSearchCondition<ForgotPassword>(Request.GetQueryNameValuePairs());

        //        var result = _ForgotPasswordBAL.GetAll(paginationFilter);
        //        if (result == null)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
        //        }
        //        else
        //        {
        //            var jsonData = new
        //            {
        //                total = result.TotalPages,
        //                result.CurrentPage,
        //                records = result.TotalRecords,
        //                rows = result.RecordsList
        //            };
        //            responseObject = jsonData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, jsonData);
        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}

        //[HttpGet]
        //[Route("Get/{Id}")]
        //public HttpResponseMessage Get(int Id)
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //        var result = _ForgotPasswordBAL.Get(Id);
        //        if (result == null)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
        //        }
        //        else
        //        {
        //            var serialisedData = JsonConvert.SerializeObject(result);
        //            responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
        //        }

        //        Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}

        //[HttpGet]
        //[Route("Delete/{Id}")]
        //public HttpResponseMessage Delete(int Id)
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
        //        _ForgotPasswordBAL.Delete(Id);
        //        responseObject = BuildResponseObject(HttpStatusCode.OK, string.Empty);
        //        Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}
    }
}
