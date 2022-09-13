namespace UETrack.Application.Web.API
{
    using CP.UETrack.Application.Web.API;
    using CP.Framework.Common.Audit;
    using System;
    using System.Net;
    using System.Net.Http;
    using System.Web.Http;
    using CP.UETrack.CodeLib.Helpers;
    using CP.ASIS.DAL.Helper;

    [RoutePrefix("api/Home")]
    [WebApiAudit]
    public class HomeAPIController : BaseApiController
    {
        private readonly string _fileName = nameof(HomeAPIController);
       
        public HomeAPIController()
        {
            
        }
        
        [HttpGet]
        [Route(nameof(HelloApi))]
        public HttpResponseMessage HelloApi()
        {            
            var helloMessage = string.Format("UETrack App Server | Internal API | Server time is now {0}", DateTime.Now);
            responseObject = BuildResponseObject(HttpStatusCode.OK, helloMessage);

            return responseObject;
        }

        [HttpGet]
        [Route(nameof(GetSvnInfo))]
        public HttpResponseMessage GetSvnInfo()
        {

            var svnInfo = HtmlHelper.GetSvnInfo();
            responseObject = BuildResponseObject(HttpStatusCode.OK, svnInfo);
            return responseObject;
        }

         [HttpGet]
        [Route(nameof(GetDbInfo))]
        public HttpResponseMessage GetDbInfo()
        {
            var dbInfo = DbHelper.GetDbInfo();
            responseObject = BuildResponseObject(HttpStatusCode.OK, dbInfo);

            return responseObject;

        }
    }
}