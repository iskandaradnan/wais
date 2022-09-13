using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
//using CP.UETrack.BLL.BusinessAccess.Contracts.LLS;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using CP.UETrack.Model.BEMS;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction;
using CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction;

namespace UETrack.Application.Web.API.API.LLS.Transaction
{
    [RoutePrefix("api/CentralLinenStoreHKeeping")]
    [WebApiAudit]
    public class CentralLinenStoreHKeepingApiController : BaseApiController
    {
        private readonly ICentralLinenStoreHouseKeepingBAL _bal;
        private readonly string fileName = nameof(CentralLinenStoreHKeepingApiController);


        public CentralLinenStoreHKeepingApiController(ICentralLinenStoreHouseKeepingBAL bal)
        {
            _bal = bal;
        }

       

    [HttpGet]
    [Route(nameof(Load))]
    public HttpResponseMessage Load()
    {

        try
        {
            Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
            var result = _bal.Load();
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
    public HttpResponseMessage Save(CentralLinenStoreHousekeepingModel model)
    {
        try
        {
            var ErrorMessage = string.Empty;
            var result = _bal.Save(model, out ErrorMessage);

            if (ErrorMessage != string.Empty)
            {
                responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
            }
            else
            {

                    if (result == null || result.HouseKeepingId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _bal.Get(result.HouseKeepingId);

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


    [HttpGet]
    [Route("Get/{Id}")]
    public HttpResponseMessage Get(int Id)
    {

        try
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
            var result = _bal.Get(Id);
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
        [Route("HKeeping/{StoreType}/{Year}/{Month}/{pagesize}/{pageindex}")]
        public HttpResponseMessage HKeeping(int StoreType, int Year, int Month, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _bal.HKeeping(StoreType, Year, Month,  pagesize, pageindex);
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
    [Route(nameof(GetAll))]
    public HttpResponseMessage GetAll()
    {

        try
        {
            Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());

            SortPaginateFilter paginationFilter = null;

            paginationFilter = GridHelper.GetAllFormatSearchCondition<CentralLinenStoreHousekeepingModel>(Request.GetQueryNameValuePairs());
            var commonDAL = new CommonDAL();
            paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

            var result = _bal.GetAll(paginationFilter);
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
            _bal.Delete(Id, out ErrorMessage);
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
}
}