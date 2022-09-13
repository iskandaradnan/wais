//using FluentValidation;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using CP.UETrack.Model;
using System.Net;
using System.Web.Http.ModelBinding;
using System.Linq;
using CP.UETrack.TranslationManager;
using CP.Framework.Common.StateManagement;
using System.Web;
using CP.UETrack.Model.BEMS;
using System.IO;
using System;

namespace CP.UETrack.Application.Web.API
{
    public class BaseApiController : ApiController
    {
        internal ResourceFileHelper resxFileHelper = new ResourceFileHelper();
        internal BaseApiController()
        {
        }

        //internal string GetFormattedErrors(ValidationException ex)
        //{
        //    var sb = new StringBuilder();
        //    foreach (var error in ex.Errors)
        //    {
        //        sb.Append(error.PropertyName + " - " + error.ErrorMessage + "<br/>");
        //    }
        //    return sb.ToString();

        //}

        #region "Helper"

        internal HttpResponseMessage BuildResponseObject(bool isSuccess, string returnMessage)
        {
            //return BuildResponseObject(HttpStatusCode.InternalServerError, isSuccess, returnMessage);
            return BuildResponseObject(HttpStatusCode.NoContent, isSuccess, returnMessage);
        }

        internal HttpResponseMessage BuildResponseObject(HttpStatusCode statusCode, bool isSuccess, string returnMessage)
        {
            var transactionInfo = new TransactionalInformation();
            transactionInfo.ReturnStatus = isSuccess;
            transactionInfo.ReturnMessage.Add(returnMessage);
            return BuildResponseObject(statusCode, transactionInfo);
        }

        //internal HttpResponseMessage BuildResponseObject(HttpStatusCode statusCode, bool isSuccess, ValidationException ex)
        //{
        //    var transactionInfo = new TransactionalInformation();
        //    transactionInfo.ReturnStatus = isSuccess;
        //    foreach (var error in ex.Errors)
        //    {
        //        transactionInfo.ReturnMessage.Add(error.PropertyName + " - " + error.ErrorMessage);
        //    }
        //    return BuildResponseObject(statusCode, transactionInfo);
        //}

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

        internal dynamic GetQueryFiltersForGetAll()
        {
            var qs = Request.GetQueryNameValuePairs().ToList();
            var qsStr = string.Empty;
            qs.ForEach(x => qsStr += string.Format("&{0}={1}", x.Key, HttpUtility.UrlEncode(x.Value)));
            return qsStr;

        }
        
        #endregion

        internal int GetHospitalIdFromHeader()
        {
            var hospitalId = Request.Headers.GetValues("HospitalId").FirstOrDefault();

            int id = 0;

            int.TryParse(hospitalId, out id);

            return id;
        }

        //internal static void FileUploadCreate(dynamic pathSoucre, FileUploadDetModel fileAttach)
        //{
        //    try
        //    {
        //        if (!string.IsNullOrEmpty(fileAttach.contentAsBase64String))
        //        {
        //            var fullPath = System.IO.Path.Combine(pathSoucre, fileAttach.FileName);
        //            FileInfo fileex = new FileInfo(fullPath);
        //            if (fileex.Exists)
        //            {
        //                fileex.Delete();
        //            }
        //            var bytes = Convert.FromBase64String(fileAttach.contentAsBase64String);
        //            using (FileStream file = File.Create(fullPath))
        //            {
        //                // fileAttach.FilePath = fullPath;
        //                file.Write(bytes, 0, bytes.Length);
        //                file.Close();
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        throw (ex);
        //    }
        //}

    }
}

