using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using CP.UETrack.TranslationManager;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.VM
{
    [RoutePrefix("api/VMMonthClosingAPI")]
    [WebApiAudit]
    public class VMMonthClosingAPIController : BaseApiController
    {
        internal string returnMessage;
        internal HttpResponseMessage responseObject;
        internal ResourceFileHelper resxFileHelper = new ResourceFileHelper();
        internal UserDetailsModel userSession;
        private readonly IVMMonthClosingBAL _VMMonthClosingBAL;
        private readonly string fileName = nameof(VMMonthClosingAPIController);

        public VMMonthClosingAPIController(IVMMonthClosingBAL VMMonthClosingBAL)
        {

            _VMMonthClosingBAL = VMMonthClosingBAL;
        }
        [HttpGet]
        [Route("Load")]
        public HttpResponseMessage Load()
        {
            Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _VMMonthClosingBAL.Load();



                responseObject = BuildResponseObject(HttpStatusCode.Created, modelTxn);

                //}
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
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
        [HttpPost]
        [Route("Get")]
        public HttpResponseMessage Get(FetchMonthClosingDetails level)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId


                var modelTxn = _VMMonthClosingBAL.Get(level);



                responseObject = (modelTxn == null) ?
                             BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                             BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                //}
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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

        [HttpPost]
        [Route("MonthClose")]
        public HttpResponseMessage MonthClose(VMMonthClosingEntity model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(MonthClose), Level.Info.ToString());

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


                _VMMonthClosingBAL.MonthClose( model);
                var modelTxn = model;
                //if (ErrorMessage != string.Empty)
                //{
                //    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, fa);
                //}
                //else
                //{

                responseObject = (modelTxn == null) ?
                             BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                             BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

                //}
                Log4NetLogger.LogExit(fileName, nameof(MonthClose), Level.Info.ToString());
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
        [Route("Getall")]
        public HttpResponseMessage GetAll()
        {
            Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;


                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<GetallEntity>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId
                var pagfilter = new GetallEntity
                {
                    QueryWhereCondition = paginationFilter.QueryWhereCondition,
                    rules = paginationFilter.rules,
                    AccessLevel = paginationFilter.AccessLevel,
                    TotalPages = paginationFilter.TotalPages,
                    TotalRecords = paginationFilter.TotalRecords,
                    WhereCondition = paginationFilter.WhereCondition,
                    PageSize = paginationFilter.PageSize,
                    PageIndex = paginationFilter.PageIndex,
                    Filters = paginationFilter.Filters,
                    Search = paginationFilter.Search,
                    SortOrder = paginationFilter.SortOrder,
                    SortColumn = paginationFilter.SortColumn,
                    Rows = paginationFilter.Rows,
                    Page = paginationFilter.Page
                };

               
                foreach (var item in Request.GetQueryNameValuePairs())
                {
                    if (item.Key == "Flag")
                    {
                        pagfilter.Flag = item.Value;
                    }
                    
                    if (item.Key == "VariationStatus")
                    {
                        pagfilter.VariationStatus = item.Value;
                    }
                    if (item.Key == "ServiceId")
                    {
                        pagfilter.ServiceId =Convert.ToInt32(item.Value);
                    }
                    if (item.Key == "Month")
                    {
                        pagfilter.Month = Convert.ToInt32(item.Value);
                    }
                    if (item.Key == "Year")
                    {
                        pagfilter.Year = Convert.ToInt32(item.Value);
                    }


                }
            
                var result = _VMMonthClosingBAL.Getall(pagfilter);

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

    }
}
