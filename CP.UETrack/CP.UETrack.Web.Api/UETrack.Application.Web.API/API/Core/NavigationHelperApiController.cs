using CP.UETrack.Application.Web.API;
using CP.UETrack.BLL.BusinessAccess;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.Framework.Common.Logging;
using System;
using Newtonsoft.Json;
using System.Net;
using System.Net.Http;

namespace UETrack.Application.Web.API
{
    [WebApiAudit]
    [RoutePrefix("api/navigationhelper")]
    public class NavigationHelperApiController : BaseApiController
    {
        private INavigationBAL _NavigationBAL;
        private readonly string _FileName = nameof(NavigationHelperApiController);

        public NavigationHelperApiController(INavigationBAL navigationBAL)
        {
            _NavigationBAL = navigationBAL;
        }

        [HttpGet]
        [Route(nameof(GetAllMenuItems))]
        public HttpResponseMessage GetAllMenuItems()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAllMenuItems), Level.Info.ToString());
                var result = _NavigationBAL.GetAllMenuItems();
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    //var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, result);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetAllMenuItems), Level.Info.ToString());
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
        [Route("actionpermissioncacheddata")]
        public HttpResponseMessage ActionPermissionCachedData()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAllMenuItems), Level.Info.ToString());
                var result = _NavigationBAL.ActionPermissionCachedData();
                responseObject = BuildResponseObject(HttpStatusCode.OK, result);
                
                Log4NetLogger.LogExit(_FileName, nameof(GetAllMenuItems), Level.Info.ToString());
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
        [Route("GetThemeColor")]
        public HttpResponseMessage GetThemeColor()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetThemeColor), Level.Info.ToString());
                var result = _NavigationBAL.GetThemeColor();
                responseObject = BuildResponseObject(HttpStatusCode.OK, result);

                Log4NetLogger.LogExit(_FileName, nameof(GetThemeColor), Level.Info.ToString());
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