using System;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using System.Net.Http.Headers;
using CP.Framework.Common.Logging;

namespace CP.Framework.Common.Sms
{
    public static class SmsSender
    {
        public static string GetLoginToken(string userid, string password)
        {
            var token = string.Empty;
            string valueToHash = string.Format("{0}:{1}", userid, password);
            byte[] signature = Encoding.UTF8.GetBytes(valueToHash);
            token = Convert.ToBase64String(signature);
            return token;
        }
        public static string SendSms(string destinationNo, string message, string uridata)
        {
            var log = new Log4NetLogger();
            log.LogEntry("Begin: SendSms");
            var returnMessage = string.Empty;
            var ReasonPhrase = string.Empty;
            Task<HttpResponseMessage> response = null;
            var uricollection = uridata.Split('$');
            var baseUri = uricollection[0];
            var uri = uricollection[1];
            var userid = uricollection[2];
            var password = uricollection[3];           
            try
            {
                response = CallProviderApi(destinationNo, message, baseUri, uri, userid, password);
                ReasonPhrase = response.Result.ReasonPhrase;
            }
            catch (TaskCanceledException ex)
            {                
                log.LogMessage(string.Format("CancellationToken: {0}", ex.CancellationToken), Level.Error);
                log.LogMessage(string.Format("InnerException: {0}", ex.InnerException), Level.Error);
                log.LogMessage(string.Format("StackTrace: {0}", ex.StackTrace), Level.Error);
            }
            catch (Exception ex)
            {
                log.LogMessage(string.Format("Message: {0}", ex.Message), Level.Error);
            }
            log.LogExit("End: BaseException");
            return ReasonPhrase;
        }

        public static async Task<HttpResponseMessage> CallProviderApi(string destinationNo, string message, string baseuri, string uri, string userid, string password)
        {
            var log = new Log4NetLogger();
            log.LogEntry("Begin: CallProviderApi");
            Task<HttpResponseMessage> response = null;
            try
            {
                var jsonContentType = new MediaTypeWithQualityHeaderValue(@"application/json");
                var ts = new TimeSpan(0, 2, 0);
                using (HttpClient clientGet = new HttpClient { BaseAddress = new Uri(baseuri), Timeout = ts })
                {
                    clientGet.DefaultRequestHeaders.Accept.Add(jsonContentType);
                    clientGet.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", GetLoginToken(userid, password));
                    var providerUri = new Uri(string.Format(uri, destinationNo, message));
                    response = clientGet.GetAsync(providerUri);
                    return response.Result;
                }

            }
            catch (TaskCanceledException ex)
            {
                //Log4NetLogger.LogEntry(ex.Message, string.Format("SmsSender | {0} occured for CallProviderApi on {1}", nameof(TaskCanceledException), uri), ex.Message);
                log.LogMessage(string.Format("InnerException: {0}", ex.InnerException), Level.Error);
            }
            catch (Exception ex)
            {
                //Log4NetLogger.LogEntry(ex.Message, string.Format("SmsSender | {0} occured for CallProviderApi on {1}", nameof(Exception), uri), ex.Message);
                log.LogMessage(string.Format("Message: {0}", ex.Message), Level.Error);
            }
            log.LogExit("End: CallProviderApi");
            return new HttpResponseMessage(System.Net.HttpStatusCode.ExpectationFailed);
        }
    }
}
