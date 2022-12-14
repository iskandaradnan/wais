using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.SmartAssign;
using CP.UETrack.BLL.BusinessAccess.Contracts.UM;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.UM
{
    [RoutePrefix("api/PorteringSmartAssign")]
    [WebApiAudit]
    public class PorteringSmartAssignApiController : BaseApiController
    {
        IPorteringSmartAssignBAL _PorteringSmartAssignBAL;
        private readonly string _FileName = nameof(PorteringSmartAssignApiController);
        public PorteringSmartAssignApiController(IPorteringSmartAssignBAL PorteringSmartAssignBAL)
        {
            _PorteringSmartAssignBAL = PorteringSmartAssignBAL;
        }

        [HttpGet]
        [Route(nameof(PorteringSmartAssignGetAll))]
        public HttpResponseMessage PorteringSmartAssignGetAll()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringSmartAssignGetAll), Level.Info.ToString());

                SortPaginateFilter paginationFilter = null;

                paginationFilter = GridHelper.GetAllFormatSearchCondition<SmartAssign>(Request.GetQueryNameValuePairs());
                var commonDAL = new CommonDAL();
                paginationFilter = commonDAL.GetProperPaginationFilter(paginationFilter);

                var result = _PorteringSmartAssignBAL.PorteringSmartAssignGetAll(paginationFilter);
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
                Log4NetLogger.LogExit(_FileName, nameof(PorteringSmartAssignGetAll), Level.Info.ToString());
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
