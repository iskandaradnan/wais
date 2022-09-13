using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.UETrack.TranslationManager;
using CP.Framework.Common.Audit;
using CP.Framework.Security.Authentication;
using FluentValidation;
using System;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using CP.UETrack.Models;
using CP.UETrack.BLL.BusinessAccess.Interface;
using Newtonsoft.Json;
using CP.Framework.Common.Logging;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/account")]
    [WebApiAudit]
    public class AccountApiController : BaseApiController
    {
        IAccountBAL _accountBAL;
        IAuthenticationService _authenticationService;
        private readonly string _FileName = nameof(UserRoleApiController);

        /// <summary>
        /// Constructor
        /// </summary>
        public AccountApiController(IAccountBAL accountBAL, IAuthenticationService authenticationService)
        {
            _accountBAL = accountBAL;
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="loginUser"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost]
        [Route(nameof(LoginAccount))]
        public HttpResponseMessage LoginAccount(LoginViewModel loginUser)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoginAccount), Level.Info.ToString());

                var result = _accountBAL.IsAuthenticated(BuildViewModel(loginUser));
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(LoginAccount), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        
        [AllowAnonymous]
        [HttpPost]
        [Route(nameof(LoginForChangePassword))]
        public HttpResponseMessage LoginForChangePassword(HttpRequestMessage request, [FromBody] LoginViewModel loginUser)
        {
            var returnMessage = string.Empty;
            var isSuccessReponse = false;
            try
            {
                //if (_accountBAL.IsAuthenticated(loginUser))
                //{
                //    isSuccessReponse = true;
                //    returnMessage = "User Authenicated.";
                //}
                //else
                //{
                //    returnMessage = "Invalid credentials.";
                //}
            }
            catch (ValidationException ex)
            {
                var sb = new StringBuilder();
                foreach (var error in ex.Errors)
                {
                    sb.Append(error.PropertyName + " - " + error.ErrorMessage + "<br/>");
                }
                returnMessage = sb.ToString();

            }
            catch (Exception)
            {
                ResourceFileHelper.GetErrorMessage("GeneralException");
            }
            return BuildTransactionalInformation(isSuccessReponse, returnMessage);
        }

        #region "Helper"
        /// <summary>
        /// Build Transactional Information
        /// </summary>
        /// <param name="IsSuccess"></param>
        /// <param name="Message"></param>
        /// <returns></returns>
        private HttpResponseMessage BuildTransactionalInformation(bool IsSuccess, string Message)
        {
            TransactionalInformation transaction = new TransactionalInformation();
            transaction.ReturnStatus = IsSuccess;
            transaction.ReturnMessage.Add(Message);
            return Request.CreateResponse<TransactionalInformation>((IsSuccess) ? HttpStatusCode.OK : HttpStatusCode.BadRequest, transaction);
        }

        /// <summary>
        /// BuildViewModel
        /// </summary>
        /// <param name="loginUser"></param>
        /// <returns></returns>
        private LoginViewModel BuildViewModel(LoginViewModel loginUser)
        {
            loginUser.Password = CP.Framework.Security.Cryptography.CryptoProvider.CreateHashValue(loginUser.Password);
            return loginUser;
        }
        #endregion

        [HttpGet]
        [Route(nameof(GetUserbyLoginName))]
        public HttpResponseMessage GetUserbyLoginName(string LoginName)
        {
            try
            {
                //var response = _accountBAL.GetUserbyLoginName(LoginName);
                return Request.CreateResponse(HttpStatusCode.OK, "");
            }
            catch (Exception)
            {
                throw;
            }
        }

        [HttpGet]
        [Route(nameof(GetMultipleLoginSetting))]
        public HttpResponseMessage GetMultipleLoginSetting()
        {
            try
            {
                var response = _accountBAL.GetMultipleLoginSetting();
                return Request.CreateResponse(HttpStatusCode.OK, response);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [Route(nameof(UserSessionLogin))]
        public HttpResponseMessage UserSessionLogin(AboutModel LoginModel)
        {
            try
            {
                var response = _accountBAL.UserSessionLogin(LoginModel);
                return Request.CreateResponse(HttpStatusCode.OK, response);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [HttpGet]
        [Route(nameof(GetConcurrentLoggedAndVistorHistory))]
        public HttpResponseMessage GetConcurrentLoggedAndVistorHistory()
        {
            try
            {
                var response = _accountBAL.GetConcurrentLoggedAndVistorHistory();
                return Request.CreateResponse(HttpStatusCode.OK, response);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [HttpGet]
        [Route("VisitorHistoryDetails/{Selecteddate}/{HistryType}")]
        public HttpResponseMessage VisitorHistoryDetails(string Selecteddate, int? HistryType)
        {
            try
            {
                var ConvertDate = Selecteddate=="null"? null:Selecteddate.Split('-');
                var ConvertSelectdate = ConvertDate!=null? ConvertDate[2] + "-" + ConvertDate[1] + "-" + ConvertDate[0]:null;
                var response = _accountBAL.VisitorHistoryDetails(ConvertSelectdate, HistryType);
                return Request.CreateResponse(HttpStatusCode.OK, response);
            }
            catch (Exception ex)
            {
                throw;
            }
        }


    }
}
