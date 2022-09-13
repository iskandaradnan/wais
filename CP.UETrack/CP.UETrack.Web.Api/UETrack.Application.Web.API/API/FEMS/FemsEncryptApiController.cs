using System;
using System.Collections.Generic;
using CP.Framework.Common.Audit;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.Application.Web.API;
using CP.UETrack.BLL.BusinessAccess.Contracts.FEMS;
using System.Net.Http;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using System.Net;

namespace UETrack.Application.Web.API.API.FEMS
{

    [RoutePrefix("api/fems")]
    [WebApiAudit]
    public class FemsEncryptApiController : BaseApiController
    {
        private readonly IFemsEncryptBAL _bal;
        private readonly string fileName = nameof(FemsEncryptApiController);


        public FemsEncryptApiController(IFemsEncryptBAL bal)
        {
            _bal = bal;
        }

        [HttpGet]
        [Route("get/{id}")]
        public HttpResponseMessage Get(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var obj = _bal.Get(Convert.ToString(Id));
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
        


    }

}