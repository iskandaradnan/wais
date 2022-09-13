using UETrack.Application.Web.Helpers;
using CP.UETrack.Model;
using CP.UETrack.Models;
using CP.Framework.Common.Audit;
using CP.Framework.Common.StateManagement;
using CP.Framework.Security.Authentication;
using Newtonsoft.Json;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.Helper;

namespace UETrack.Application.Web.Controllers
{
    
    [RoutePrefix("api/account")]
    [WebApiAudit]
    public class AccountApiController : ApiController
    {
        IAuthenticationService _authenticationService;
        ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
        private readonly string _FileName = nameof(AccountApiController);

        ///// <summary>
        ///// Constructor
        ///// </summary>
        public AccountApiController(IAuthenticationService authenticationService)
        {
            _authenticationService = authenticationService;
        }

        /// <summary>
        /// Account Login
        /// </summary>
        /// <param name="request">request parameter on AccountLogin</param>
        /// <param name="loginUser">loginUser parameter on AccountLogin</param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost(nameof(LoginAccount))]
        public async Task<HttpResponseMessage> LoginAccount(HttpRequestMessage request, [FromBody] LoginViewModel loginUser)
        {

            Log4NetLogger.LogEntry(_FileName, nameof(LoginAccount), Level.Info.ToString());
            var isAlreadyLoggedIn = await IsUserAlreadyLoggedIn(loginUser);
            loginUser.IsAlreadyLoggedIn = isAlreadyLoggedIn;

            var result = await RestHelper.ApiPost("account/LoginAccount", loginUser);

            if (result.IsSuccessStatusCode)
            {
                HttpContext.Current.Session.Abandon();
                _authenticationService.SignIn(loginUser.LoginName.ToLower(), isPersistent: loginUser.RememberMe);
            }
            Log4NetLogger.LogExit(_FileName, nameof(LoginAccount), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SetSessionDetails))]
        public void SetSessionDetails(LoginViewModel loginUser)
        {
            //if(!loginUser.IsMultipleFacility)
            //{
            //    var userDetails = new UserDetailsModel
            //    {
            //        UserId = loginUser.UserId,
            //        UserName = loginUser.LoginName,
            //        Language = loginUser.Language,
            //        StaffName = loginUser.StaffName,
            //        AccessLevel = loginUser.AccessLevel,
            //        CustomerId = loginUser.CustomerId,
            //        FacilityId= loginUser.FacilityId
            //    };
            //    _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
            //}
            //else
            //{
            //    var userDetails = new UserDetailsModel
            //    {
            //        UserId = loginUser.UserId,
            //        UserName = loginUser.LoginName,
            //        Language = loginUser.Language,
            //        StaffName = loginUser.StaffName,
            //        AccessLevel = loginUser.AccessLevel
            //        //CustomerId = loginUser.CustomerId,
            //        //FacilityId= loginUser.FacilityId
            //    };
            //    _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
            //}
            var userDetails = new UserDetailsModel
            {
                UserId = loginUser.UserId,
                UserName = loginUser.LoginName,
                Language = loginUser.Language,
                StaffName = loginUser.StaffName,
                AccessLevel = loginUser.AccessLevel,
                CustomerId = loginUser.CustomerId,
                FacilityId= loginUser.FacilityId,
                UserTypeId = loginUser.UserTypeId
                
            };

            _sessionProvider.Set(nameof(UserDetailsModel), userDetails);
            NavigationHelper.ClearUserPermissionsCacheData(loginUser.LoginName);
        }

        private static async Task<bool> IsUserAlreadyLoggedIn(LoginViewModel loginUser)
        {
            var isAlreadyLoggedIn = false;

            try
            {
                var result = RestHelper.ApiGet("account/GetMultipleLoginSetting");
                var jonString = await result.Result.Content.ReadAsStringAsync();
                var allowMultipleLogins = JsonConvert.DeserializeObject<bool>(jonString);
                if (!allowMultipleLogins)
                {
                    loginUser.AllowMultipleLogins = false;
                }
                else
                {
                    loginUser.AllowMultipleLogins = true;
                    return isAlreadyLoggedIn = false;
                }

                var cacheProvider = new DefaultCacheProvider();
                var details = cacheProvider.Get(loginUser.LoginName.ToLower());
                var sessionId = HttpContext.Current.Session.SessionID;
                if (details == null || details.ToString() == string.Empty)
                {
                    isAlreadyLoggedIn = false;
                }
                else if (details.ToString() != sessionId)
                {
                    isAlreadyLoggedIn = true;
                    loginUser.IsAlreadyLoggedIn = true;
                }
            }
            catch (Exception)
            {
                isAlreadyLoggedIn = false;
            }
            return isAlreadyLoggedIn;
        }

        [AllowAnonymous]
        [HttpPost(nameof(SignIn))]
        public HttpResponseMessage SignIn(HttpRequestMessage request, [FromBody] LoginViewModel loginUser)
        {
            var isSuccessReponse = true;
            var returnMessage = string.Empty;
            try
            {
                HttpContext.Current.Session.Abandon();
                _authenticationService.SignIn(loginUser.LoginName.ToLower(), isPersistent: loginUser.RememberMe);

                var cacheProvider = new DefaultCacheProvider();
                var sessionId = HttpContext.Current.Session.SessionID;
                cacheProvider.Clear(loginUser.LoginName.ToLower());
                cacheProvider.Set(loginUser.LoginName.ToLower(), sessionId);

                returnMessage = "User signed in";
            }
            catch (Exception ex)
            {
                isSuccessReponse = false;
                returnMessage = ex.Message;
            }

            return BuildTransactionalInformation(isSuccessReponse, returnMessage);
        }

        [AllowAnonymous]
        [HttpPost("LoginForChangePassword")]
        public Task<HttpResponseMessage> LoginForChangePassword(HttpRequestMessage request, [FromBody] LoginViewModel loginUser)
        {

            var result = RestHelper.ApiPost("account/LoginForChangePassword", loginUser);

            if (result.Result.IsSuccessStatusCode)
            {
                HttpContext.Current.Session.Abandon();
            }

            return result;

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

        [AllowAnonymous]
        [HttpGet(nameof(GetUserbyLoginName))]
        public Task<HttpResponseMessage> GetUserbyLoginName(string LoginName)
        {

            var result = RestHelper.ApiGet("account/GetUserbyLoginName?LoginName=" + LoginName);
            return result;
        }
        [AllowAnonymous]
        [HttpGet(nameof(GetPermissionCheck))]
        public Task<HttpResponseMessage> GetPermissionCheck()
        {
            var result = RestHelper.ApiGet("account/GetPermissionCheck");
            return result;
        }

        [AllowAnonymous]
        [HttpGet(nameof(GetConcurrentLoggedAndVistorHistory))]
        public Task<HttpResponseMessage> GetConcurrentLoggedAndVistorHistory()
        {
            var result = RestHelper.ApiGet("account/GetConcurrentLoggedAndVistorHistory");
            return result;
        }


        [HttpGet("VisitorHistoryDetails/{Selecteddate}/{HistryType}")]
        public Task<HttpResponseMessage> VisitorHistoryDetails(string Selecteddate, int? HistryType)
        {           
            var result = RestHelper.ApiGet(string.Format("account/VisitorHistoryDetails/{0}/{1}", Selecteddate, HistryType));
            return result;
        }


    }
}
