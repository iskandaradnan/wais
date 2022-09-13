using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace UETrack.Application.Web.Controllers
{
    [RoutePrefix("api/DeptAreaDetails")]
    [WebApiAudit]
    public class DeptAreaDetailsApiController : BaseApiController
    {

        IDeptAreaDetailsBAL _deptAreaDetailsBAL;
        private readonly string _FileName = nameof(BlockApiController);
        private readonly ICommonBAL _commonBAL;

        public DeptAreaDetailsApiController(IDeptAreaDetailsBAL deptAreaDetailsBAL, ICommonBAL common)
        {
            _deptAreaDetailsBAL = deptAreaDetailsBAL;
            _commonBAL = common;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _deptAreaDetailsBAL.Load();
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
        public HttpResponseMessage Save(DeptAreaDetails model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _deptAreaDetailsBAL.Save(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));                    
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

        [HttpPost]
        [Route(nameof(SaveRecp))]
        public HttpResponseMessage SaveRecp(Receptacles model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _deptAreaDetailsBAL.SaveRecp(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));                    
                }
                Log4NetLogger.LogExit(_FileName, nameof(SaveRecp), Level.Info.ToString());
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
        [Route(nameof(SaveDailyClean))]
        public HttpResponseMessage SaveDailyClean(DailyCleaningSchedule model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _deptAreaDetailsBAL.SaveDailyClean(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(SaveDailyClean), Level.Info.ToString());
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
        [Route(nameof(SavePeriodicWork))]
        public HttpResponseMessage SavePeriodicWork(PeriodicWorkSchedule model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _deptAreaDetailsBAL.SavePeriodicWork(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(SavePeriodicWork), Level.Info.ToString());
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
        [Route(nameof(SaveToilet))]
        public HttpResponseMessage SaveToilet(List<Toilet> _lsttoilet)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _deptAreaDetailsBAL.SaveToilet(_lsttoilet, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(SaveToilet), Level.Info.ToString());
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
        [Route(nameof(SaveDispenser))]
        public HttpResponseMessage SaveDispenser(Dispenser model)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _deptAreaDetailsBAL.SaveDispenser(model, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(SaveDispenser), Level.Info.ToString());
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
        [Route(nameof(SaveVariationDetails))]
        public HttpResponseMessage SaveVariationDetails(List<VariationDetails> _lstVariationDetails)
        {
            try
            {
                var ErrorMessage = string.Empty;
                var result = _deptAreaDetailsBAL.SaveVariationDetails(_lstVariationDetails, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    responseObject = BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(result));
                }
                Log4NetLogger.LogExit(_FileName, nameof(SaveVariationDetails), Level.Info.ToString());
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

                paginationFilter = GridHelper.GetAllFormatSearchCondition<DeptAreaDetails>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                var result = _deptAreaDetailsBAL.GetAll(paginationFilter);

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
                var result = _deptAreaDetailsBAL.Get(Id);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
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


        [HttpPost]
        [Route(nameof(UserAreaCodeFetch))]
        public HttpResponseMessage UserAreaCodeFetch(DeptAreaDetails dept)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _deptAreaDetailsBAL.UserAreaCodeFetch(dept);

                if(ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
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