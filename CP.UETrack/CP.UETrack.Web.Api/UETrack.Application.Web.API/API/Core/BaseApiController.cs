using CP.UETrack.Model;
using CP.UETrack.TranslationManager;
using FluentValidation;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using System.Web.Http.ModelBinding;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Web;
using System;

namespace CP.UETrack.Application.Web.API
{
    public class BaseApiController : ApiController
    {
        internal string returnMessage;
        internal HttpResponseMessage responseObject;
        internal ResourceFileHelper resxFileHelper = new ResourceFileHelper();
        internal UserDetailsModel userSession;
        internal string RecordModifiedErrorMessage;
        internal BaseApiController()
        {
            userSession = GetUserDetails();
            RecordModifiedErrorMessage = Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["RecordModifiedErrorMessage"]);
        }

        internal string GetFormattedErrors(ValidationException ex)
        {
            var sb = new StringBuilder();
            foreach (var error in ex.Errors)
            {
                sb.Append(error.PropertyName + " - " + error.ErrorMessage + "<br/>");
            }
            return sb.ToString();

        }

        #region "Helper"


        internal HttpResponseMessage BuildResponseObject(bool isSuccess, string returnMessage)
        {
            if (returnMessage != null && returnMessage.Contains("RECORDMODIFIED"))
            {
                returnMessage = RecordModifiedErrorMessage;
            }
            return BuildResponseObject(HttpStatusCode.InternalServerError, isSuccess, returnMessage);
        }

        internal HttpResponseMessage BuildResponseObject(HttpStatusCode statusCode, bool isSuccess, string returnMessage)
        {
            if (returnMessage != null && returnMessage.Contains("RECORDMODIFIED"))
            {
                returnMessage = RecordModifiedErrorMessage;
            }
            var transactionInfo = new TransactionalInformation();
            transactionInfo.ReturnStatus = isSuccess;
            transactionInfo.ReturnMessage.Add(returnMessage);
            return BuildResponseObject(statusCode, transactionInfo);
        }

        internal HttpResponseMessage BuildResponseObject(HttpStatusCode statusCode, bool isSuccess, ValidationException ex)
        {
            var transactionInfo = new TransactionalInformation();
            transactionInfo.ReturnStatus = isSuccess;
            foreach (var error in ex.Errors)
            {
                transactionInfo.ReturnMessage.Add(error.PropertyName + " - " + error.ErrorMessage);
            }
            return BuildResponseObject(statusCode, transactionInfo);
        }

        internal HttpResponseMessage BuildResponseObject(HttpStatusCode statusCode, bool isSuccess, ModelStateDictionary modelState)
        {
            var transactionInfo = new TransactionalInformation();
            transactionInfo.ReturnStatus = isSuccess;
            if (!modelState.IsValid)
            {
                foreach (var values in modelState.Values)
                    foreach (var error in values.Errors)
                        transactionInfo.ReturnMessage.Add(error.Exception.Message);
            }
            return BuildResponseObject(statusCode, transactionInfo);
        }

        internal HttpResponseMessage BuildResponseObject(HttpStatusCode statusCode)
        {
            return Request.CreateResponse(statusCode);
        }

        internal HttpResponseMessage BuildResponseObject(HttpStatusCode statusCode, object responseObject)
        {
            return Request.CreateResponse(statusCode, responseObject);
        }
        internal HttpResponseMessage BuildResponseObject(HttpStatusCode StatusCode, string ErrorMessage)
        {
            return Request.CreateResponse(StatusCode, ErrorMessage);
        }

        internal UserDetailsModel GetUserDetails()
        {
            var userDetails = new UserDetailsModel();

            var userinfo = HttpContext.Current.Request.Headers.GetValues(nameof(UserDetailsModel));
            if (userinfo != null)
            {
                var jss = new JavaScriptSerializer();
                userDetails = jss.Deserialize<UserDetailsModel>(userinfo.FirstOrDefault());
            }

            return userDetails;
        }


        #endregion

        internal int GetHospitalIdFromHeader()
        {
            var hospitalId = Request.Headers.GetValues("HospitalId").FirstOrDefault();

            int id = 0;

            int.TryParse(hospitalId, out id);

            return id;
        }

        internal int GetUserIdFromHeader()
        {
            var userId = Request.Headers.GetValues("UserId").FirstOrDefault();

            int id = 0;

            int.TryParse(userId, out id);

            return id;
        }
        internal List<int> GetDetailsFromHeader()
        {
            var hospitalId = GetHospitalIdFromHeader();
            var userId = GetUserIdFromHeader();

            var companyId = Request.Headers.GetValues("CompanyId").FirstOrDefault();
            int compId = 0;
            int.TryParse(companyId, out compId);

            var headerDetails = new List<int>();
            headerDetails.Add(userId);
            headerDetails.Add(compId);
            headerDetails.Add(hospitalId);

            return headerDetails;
        }
    }
}

