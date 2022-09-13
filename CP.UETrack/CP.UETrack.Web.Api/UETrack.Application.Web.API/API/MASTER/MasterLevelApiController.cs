using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.BLL.BusinessAccess;
using System.Linq;
using CP.UETrack.Application.Web.API.Helpers;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/MasterLevel")]
    [WebApiAudit]
    public class MasterLevelApiController : BaseApiController
    {
        IMasterLevelBAL _LevelBAL;
        
        private readonly string _FileName = nameof(MasterLevelApiController);
        private readonly ICommonBAL _commonBAL;
        //public MasterLevelApiController()
        //{
        //    _LevelBAL = new MasterLevelBAL();
           
        //}
        public MasterLevelApiController(IMasterLevelBAL accountBAL, ICommonBAL common)
        {
            _LevelBAL = accountBAL;
            _commonBAL = common;
        }


        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _LevelBAL.Load();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
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
        public HttpResponseMessage Save(LevelMstViewModel level)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _LevelBAL.Save(level, out ErrorMessage);

                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
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
                
                paginationFilter = GridHelper.GetAllFormatSearchCondition<LevelMstViewModel>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var modelName = nameof(LevelMstViewModel);
                var result = _commonBAL.GetAll(paginationFilter, modelName);

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

        //[HttpGet]
        //[Route(nameof(MasterGetAll))]
        //public HttpResponseMessage MasterGetAll()
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());

        //        SortPaginateFilter paginationFilter = null;

        //        paginationFilter = GridHelper.GetAllFormatSearchCondition<LevelMstViewModel>(Request.GetQueryNameValuePairs());
        //        var commonDAL = new CommonDAL();
        //        paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

        //        var modelName = nameof(LevelMstViewModel);
        //        var result = _commonBAL.MasterGetAll(paginationFilter, modelName);

        //        if (result == null)
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
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

        [HttpGet]
        [Route("Get/{Id}")]
        public HttpResponseMessage Get(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _LevelBAL.Get(Id);
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

        [HttpGet]
        [Route("GetBlockData/{levelFacilityId}")]
        public HttpResponseMessage GetBlockData(int levelFacilityId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _LevelBAL.GetBlockData(levelFacilityId);
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

        [HttpGet]
        [Route("Delete/{Id}")]
        public HttpResponseMessage Delete(int Id)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _LevelBAL.Delete(Id);
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

//        #region Master
//        [HttpGet]
//        [Route(nameof(MasterLoad))]
//        public HttpResponseMessage MasterLoad()
//        {

//            try
//            {
//                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
//                var result = _LevelBAL.Load();
//                var serialisedData = JsonConvert.SerializeObject(result);
//                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
//                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
//            }
//            catch (Exception ex)
//            {
//                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
//            }

//            if (responseObject == null)
//                responseObject = BuildResponseObject(false, returnMessage);

//            return responseObject;
//        }

//        [HttpPost]
//        [Route(nameof(MasterSave))]
//        public HttpResponseMessage MasterSave(LevelMstViewModel level)
//        {

//            try
//            {
//                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
//                var ErrorMessage = string.Empty;
//                var result = _LevelBAL.Save(level, out ErrorMessage);

//                if (ErrorMessage != string.Empty)
//                {
//                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
//                }
//                else
//                {
//                    var serialisedData = JsonConvert.SerializeObject(result);
//                    responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
//                }
//                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
//            }
//            catch (Exception ex)
//            {
//                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
//            }

//            if (responseObject == null)
//                responseObject = BuildResponseObject(false, returnMessage);

//            return responseObject;
//        }

//        [HttpGet]
//        [Route(nameof(MasterGetAll))]
//        public HttpResponseMessage MasterGetAll()
//        {

//            try
//            {
//                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());

//                SortPaginateFilter paginationFilter = null;

//                paginationFilter = GridHelper.GetAllFormatSearchCondition<LevelMstViewModel>(Request.GetQueryNameValuePairs());
//                var commonDAL = new CommonDAL();
//                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

//                var modelName = nameof(LevelMstViewModel);
//                var result = _commonBAL.GetAll(paginationFilter, modelName);

//                if (result == null)
//                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
//                else
//                {
//                    var jsonData = new
//                    {
//                        total = result.TotalPages,
//                        result.CurrentPage,
//                        records = result.TotalRecords,
//                        rows = result.RecordsList
//                    };
//                    responseObject = jsonData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, jsonData);
//                }
//                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
//            }
//            catch (Exception ex)
//            {
//                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
//            }

//            if (responseObject == null)
//                responseObject = BuildResponseObject(false, returnMessage);

//            return responseObject;
//        }

//        [HttpGet]
//        [Route("MasterGet/{Id}")]
//        public HttpResponseMessage MasterGet(int Id)
//        {

//            try
//            {
//                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
//                var result = _LevelBAL.Get(Id);
//                var serialisedData = JsonConvert.SerializeObject(result);
//                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
//                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
//            }
//            catch (Exception ex)
//            {
//                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
//            }

//            if (responseObject == null)
//                responseObject = BuildResponseObject(false, returnMessage);

//            return responseObject;
//        }

//        [HttpGet]
//        [Route("MasterGetBlockData/{levelFacilityId}")]
//        public HttpResponseMessage MasterGetBlockData(int levelFacilityId)
//        {

//            try
//            {
//                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
//                var result = _LevelBAL.GetBlockData(levelFacilityId);
//                var serialisedData = JsonConvert.SerializeObject(result);
//                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
//                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
//            }
//            catch (Exception ex)
//            {
//                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
//            }

//            if (responseObject == null)
//                responseObject = BuildResponseObject(false, returnMessage);

//            return responseObject;
//        }

//        [HttpGet]
//        [Route("MasterDelete/{Id}")]
//        public HttpResponseMessage MasterDelete(int Id)
//        {

//            try
//            {
//                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
//                _LevelBAL.Delete(Id);
//                responseObject = BuildResponseObject(HttpStatusCode.OK, string.Empty);
//                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
//            }
//            catch (Exception ex)
//            {
//                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
//            }

//            if (responseObject == null)
//                responseObject = BuildResponseObject(false, returnMessage);

//            return responseObject;
//        }
//#endregion
    }
}
