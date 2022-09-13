using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.MASTER;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using FluentValidation;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.MASTER
{
    [RoutePrefix("api/MasterUserArea")]
    [WebApiAudit]
    public class MasterUserAreaAPIController : BaseApiController
    {/// <summary>
     /// Standard Operating Procedures Web Api Class
     /// </summary>
        private readonly IMasterUserAreaBAL _MasterUserAreaBAL;
        private readonly string fileName = nameof(MasterUserAreaAPIController);

        public MasterUserAreaAPIController(IMasterUserAreaBAL MasterUserAreaBA)
        {
            this._MasterUserAreaBAL = MasterUserAreaBA;
           // _MasterUserAreaBAL = MasterUserAreaBA;
        }


        [HttpGet]
        [Route("Load/{id}")]
        public HttpResponseMessage Load(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _MasterUserAreaBAL.Load(Id);
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





        [HttpPost]
        [Route("Add")]
        public HttpResponseMessage Post(MstLocationUserAreaViewModel model)
        {
            Log4NetLogger.LogEntry(fileName, nameof(Post), Level.Info.ToString());

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


                var modelTxn = _MasterUserAreaBAL.Save(model, out ErrorMessage);
                if (ErrorMessage != string.Empty)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.BadRequest, ErrorMessage);
                }
                else
                {

                    responseObject = (modelTxn == null || modelTxn.UserAreaId == 0) ?
                                 BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("CreateFailed")) :
                                 BuildResponseObject(HttpStatusCode.Created, JsonConvert.SerializeObject(modelTxn));

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
        /// 

        [HttpGet]
        [Route("Delete/{Id}")]
        public HttpResponseMessage Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                _MasterUserAreaBAL.Delete(Id, out ErrorMessage);

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
                var obj = _MasterUserAreaBAL.Get(int.Parse(Id));
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
                paginationFilter = GridHelper.GetAllFormatSearchCondition<MstLocationUserAreaViewModel>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var result = _MasterUserAreaBAL.GetAll(paginationFilter);
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
