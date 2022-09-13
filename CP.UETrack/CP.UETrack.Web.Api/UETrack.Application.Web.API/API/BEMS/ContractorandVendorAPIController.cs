using CP.Framework.Common.Audit;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
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

namespace UETrack.Application.Web.API.API.BEMS
{
    [RoutePrefix("api/ContractorandVendor")]
    [WebApiAudit]
    public class ContractorandVendorAPIController : BaseApiController
    {

        /// <summary>
        /// Standard Operating Procedures Web Api Class
        /// </summary>
        private readonly IContractorandVendorBAL _contractorandVendorBAL;
        private readonly string fileName = nameof(ContractorandVendorAPIController);
        private readonly ICommonBAL _common;
        public ContractorandVendorAPIController(IContractorandVendorBAL contractorandVendorBAL, ICommonBAL common)
        {
            _contractorandVendorBAL = contractorandVendorBAL;
            _common = common;
        }
        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _contractorandVendorBAL.Load();
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
        [HttpGet]
        [Route(nameof(LoadCountry))]
        public HttpResponseMessage LoadCountry()
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(LoadCountry), Level.Info.ToString());
                var result = _contractorandVendorBAL.Load();
              //  var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = result == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, result);
                Log4NetLogger.LogExit(fileName, nameof(LoadCountry), Level.Info.ToString());
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
        [Route("add")]
        public HttpResponseMessage Post(MstContractorandVendorViewModel Contractor)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Post), Level.Info.ToString());

            try
            {
                var ErrorMessage = string.Empty;
                if (Contractor == null)
                {
                    return responseObject = BuildResponseObject(HttpStatusCode.BadRequest, false);
                }
                if (!ModelState.IsValid)
                {
                    return BuildResponseObject(HttpStatusCode.BadRequest, false, ModelState);
                }

                var userDetails = new UserDetailsModel();
                userDetails = GetUserDetails(); // Get login details with ConsortiaId and HospitalId
                

                var ContractorTxn = _contractorandVendorBAL.SaveUpdate(Contractor, out ErrorMessage);
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    if (ContractorTxn == null || ContractorTxn.ContractorId == 0)
                        BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));
                    else
                    {
                        var ResultData = _contractorandVendorBAL.Get(ContractorTxn.ContractorId);
                        // ResultData.WorkingCalendar = modelTxn;
                        responseObject = (ContractorTxn != null) ? responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(ResultData)) : responseObject = BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed"));

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
        [HttpGet]
        [Route("Delete/{Id}")]
        public HttpResponseMessage Delete(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                _contractorandVendorBAL.Delete(Id, out ErrorMessage);

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
                var contractorObj = _contractorandVendorBAL.Get(int.Parse(Id));
                var serialisedData = JsonConvert.SerializeObject(contractorObj);
                if (contractorObj == null)
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
                paginationFilter = GridHelper.GetAllFormatSearchCondition<MstContractorandVendorViewModel>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var modelName = nameof(MstContractorandVendorViewModel);
                var result = _common.GetAll(paginationFilter, modelName);
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

    }

    
}
