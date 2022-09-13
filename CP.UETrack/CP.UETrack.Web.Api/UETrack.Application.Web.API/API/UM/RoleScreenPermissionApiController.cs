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
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/roleScreenPermission")]
    [WebApiAudit]
    public class RoleScreenPermissionApiController : BaseApiController
    {
        IRoleScreenPermissionBAL _RoleScreenPermissionBAL;
        private readonly string _FileName = nameof(RoleScreenPermissionApiController);
        public RoleScreenPermissionApiController(IRoleScreenPermissionBAL roleScreenPermissionBAL)
        {
            _RoleScreenPermissionBAL = roleScreenPermissionBAL;
        }

        [HttpGet]
        [Route(nameof(GetUserRoles))]
        public HttpResponseMessage GetUserRoles()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                var result = _RoleScreenPermissionBAL.GetUserRoles();
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetUserRoles), Level.Info.ToString());
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
        [Route("Fetch/{RoleId}/{ModuleId}")]
        public HttpResponseMessage Fetch(int RoleId, int ModuleId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                var result = _RoleScreenPermissionBAL.Fetch(RoleId, ModuleId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetUserRoles), Level.Info.ToString());
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
        public HttpResponseMessage Save(RoleScreenPermissions roleScreenPermissions)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _RoleScreenPermissionBAL.Save(roleScreenPermissions, out ErrorMessage);

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
        [Route("GetModules/{UserTypeId}")]
        public HttpResponseMessage GetModules(int UserTypeId)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetModules), Level.Info.ToString());
                var result = _RoleScreenPermissionBAL.GetModules(UserTypeId);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetModules), Level.Info.ToString());
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
