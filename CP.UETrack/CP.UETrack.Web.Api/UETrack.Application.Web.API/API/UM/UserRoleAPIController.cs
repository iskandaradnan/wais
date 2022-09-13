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
using System.Net.Http.Formatting;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/userRole")]
    [WebApiAudit]
    public class UserRoleApiController : BaseApiController
    {
        IUserRoleBAL _UserRoleBAL;
        private readonly string _FileName = nameof(UserRoleApiController);
        public UserRoleApiController(IUserRoleBAL userRoleBAL)
        {
            _UserRoleBAL = userRoleBAL;
        }

        [HttpGet]
        [Route(nameof(Load))]
        public HttpResponseMessage Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _UserRoleBAL.Load();
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
        public HttpResponseMessage Save(UMUserRole userRole)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _UserRoleBAL.Save(userRole, out ErrorMessage);

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
                var nameValuePairs = Request.GetQueryNameValuePairs();
                paginationFilter = GridHelper.GetAllFormatSearchCondition<UMUserRole>(nameValuePairs);

                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);
                
                var result = _UserRoleBAL.GetAll(paginationFilter);
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
                var result = _UserRoleBAL.Get(Id);
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
                _UserRoleBAL.Delete(Id, out ErrorMessage);

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

        [HttpPost]
        [Route("export")]
        public HttpResponseMessage Export(FormDataCollection form)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());

                //var columnNames = form.GetValues("columnNames")[0];
                //var exportType = form.GetValues("exportType")[0];
                //var filters = form.GetValues("filters")[0];
                //var sortColumn = form.GetValues("sortColumnName")[0];
                //var sortType = form.GetValues("sortOrder")[0];
                //var headerNames = form.GetValues("headerColumnNames")[0];
                //var viewModelName = form.GetValues("viewModelName")[0];
                //var defaultFilters = form.GetValues("defaultFilters") == null ? string.Empty : form.GetValues("defaultFilters")[0];
                //var screenTitle = form.GetValues("screenName") == null ? string.Empty : form.GetValues("screenName")[0];

                ////if ((string.IsNullOrEmpty(viewModelName)) || (string.IsNullOrWhiteSpace(viewModelName)))
                ////{
                ////    return BuildResponseObject(false, resxFileHelper.GetErrorMessagesFromResource("GeneralException"));
                ////}

                ////var viewdomainModel = "V_" + viewModelName.Replace("ViewModel", string.Empty);
                ////var method = typeof(GridHelper).GetMethod("ExportFormatSearchCondition");
                ////var types = typeof(CommonDAL).Assembly.GetTypes().Where(t => t.Name == viewdomainModel);

                ////SortPaginateFilter paginationFilter = null;
                ////var genericMethod = method.MakeGenericMethod(types.FirstOrDefault());
                ////paginationFilter = (SortPaginateFilter)genericMethod.Invoke(null, new object[] { filters, sortColumn, sortType, defaultFilters });

                //SortPaginateFilter paginationFilter = null;

                //paginationFilter = GridHelper.GetAllFormatSearchCondition<UMUserRole>(Request.GetQueryNameValuePairs());
                //var commonDAL = new CommonDAL();
                //paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                //var exportList = new GridFilterResult();
                //exportList = _UserRoleBAL.Export(paginationFilter, exportType);

                ////var gridColumnNames = (exportList.Column_Names != string.Empty) ? exportList.Column_Names.Split(',').ToList<string>() : columnNames.Split(',').ToList<string>();
                ////var headerColumnNames = (exportList.Header_Names != string.Empty) ? exportList.Header_Names.Split(',').ToList<string>() : headerNames.Split(',').ToList<string>();
                ////var methodExport = typeof(ExportHelper).GetMethod(nameof(Export));
                ////var DomainEntity = "V_" + viewModelName.Replace("ViewModel", string.Empty);
                ////var exportTypes = typeof(FmsInitialIncidentReportTxn).Assembly.GetTypes().Where(t => t.Name == DomainEntity);
                ////var genericMethodExport = methodExport.MakeGenericMethod(exportTypes.FirstOrDefault());
                ////responseObject = (HttpResponseMessage)genericMethodExport.Invoke(null, new object[] { exportList.RecordsList, exportType.ToString().ToUpper(), gridColumnNames, headerColumnNames, screenTitle, exportList.CompanyLogo, exportList.MohLogo });

                //responseObject.StatusCode = HttpStatusCode.OK;
                //Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
                //throw new Exception("error");
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
    }
}
