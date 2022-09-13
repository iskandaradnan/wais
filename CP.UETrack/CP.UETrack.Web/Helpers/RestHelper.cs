namespace UETrack.Application.Web.Helpers
{
    using CP.UETrack.Application.Web.Filter;
    using CP.UETrack.CodeLib.Helpers;
    using CP.UETrack.Model;
    using CP.Framework.Common.Logging;
    using CP.Framework.Common.StateManagement;
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading.Tasks;
    using System.Web;
    using System.Web.Http;

    public static class RestHelper
    {

        //As per this reference: http://stackoverflow.com/questions/22560971/what-is-the-overhead-of-creating-a-new-httpclient-per-call-in-a-webapi-client/35045301#35045301
        //the HttpClient object is made static to avoid performance issue.
        static HttpClient clientGet;
        //static HttpClient clientDelete;
        //static HttpClient clientPost;
        //static HttpClient clientPut;
        //// Commented all these Static Code due to WebServer crashes for < 10 users.


        static ISessionProvider sessionProvider;

        static long requestsCount;
        static string baseUri;
        
        static RestHelper()
        {
            sessionProvider = SessionProviderFactory.GetSessionProvider();
            System.Net.ServicePointManager.DefaultConnectionLimit = 10;

            baseUri = ConfigHelper.GetConfig(@"InternalApiBaseUrl");
            
            var jsonContentType = new MediaTypeWithQualityHeaderValue(@"application/json");
            var ts = new TimeSpan(0, 2, 0);

            clientGet = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts };
            clientGet.DefaultRequestHeaders.Accept.Add(jsonContentType);

            //clientDelete = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts };
            //clientDelete.DefaultRequestHeaders.Accept.Add(jsonContentType);

            //clientPost = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts };
            //clientPost.DefaultRequestHeaders.Accept.Add(jsonContentType);

            //clientPut = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts };
            //clientPut.DefaultRequestHeaders.Accept.Add(jsonContentType);
        }

        public static long RequestsCount
        {
            get
            {
                return requestsCount;
            }
        }

        public static string ApiBaseUri
        {
            get { return baseUri; }
        }
        public static string WebBaseUri
        {
            get
            {
                var uri = new Uri(HttpContext.Current.Request.Url.AbsoluteUri);
                var UrlWithPort = uri.Scheme + Uri.SchemeDelimiter + uri.Host + ":" + uri.Port;
                if (uri.IsDefaultPort) {
                    UrlWithPort = uri.Scheme + Uri.SchemeDelimiter + uri.Host ;
                }
                return UrlWithPort;
            }
        }
        public static async Task<string> GetApiSvnInfo()
        {
            var x = await ApiGet(@"Home\GetSvnInfo", true);
            var y = await x.Content.ReadAsStringAsync();
            return y;
        }

        public static async Task<string> GetDbInfo()
        {
            try
            {
                var x = await ApiGet(@"Home\GetDbInfo", true);
                var info = await x.Content.ReadAsStringAsync();

                //var dsInfo = JSSerializerHelper.Deserialize<Tuple<string, string>>(info);
                info = info.Replace("{", string.Empty).Replace("}", string.Empty);
                var dbInfo = info.Split(',');
                var srvName = dbInfo[0].Replace("Item1", string.Empty).Replace("\"", string.Empty).Replace(":", string.Empty);
                var dbName = dbInfo[1].Replace("Item2", string.Empty).Replace("\"", string.Empty).Replace(":", string.Empty);

                return srvName + "/" + dbName;
            }
            catch (Exception ex)
            {
                var s = ex.Message;
            }

            return "<error>";

        }

        private static string getSessionInfo()
        {
            var headerData = string.Empty;
            var sessionHelper = new SessionHelper();
           
            var userDetails = (UserDetailsModel)sessionProvider.Get(nameof(UserDetailsModel));

            if (userDetails != null)
                headerData = JSSerializerHelper.Serialize(userDetails);
            return headerData;

        }

        public static Task<HttpResponseMessage> ApiGet(string url)
        {
            return ApiGet(url, false);
        }

        public static async Task<HttpResponseMessage> ApiGet(string url, bool isSessionLess)
        {
            Task<HttpResponseMessage> response = null;
            string sessionInfo = null;
            try
            {
                var jsonContentType = new MediaTypeWithQualityHeaderValue(@"application/json");
                var ts = new TimeSpan(0, 2, 0);
                using (HttpClient clientGet = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts })
                {
                    clientGet.DefaultRequestHeaders.Accept.Add(jsonContentType);

                    if (!isSessionLess)
                    {
                        sessionInfo = getSessionInfo();

                        if (!string.IsNullOrEmpty(sessionInfo))
                        {
                            clientGet.DefaultRequestHeaders.Clear();
                            clientGet.DefaultRequestHeaders.Add(nameof(UserDetailsModel), sessionInfo);
                        }
                    }

                    requestsCount++;
                    response = clientGet.GetAsync(url);

                    requestsCount--;

                    return response.Result;
                }
            }
            catch (TaskCanceledException ex)
            {
                Log4NetLogger.LogEntry(ex.Message, string.Format("RestHelper | {0} occured for Get on {1}", nameof(TaskCanceledException), url), ex.Message);
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry(ex.Message, string.Format("RestHelper | {0} occured for Get on {1}", nameof(Exception), url), ex.Message);
            }

            return new HttpResponseMessage(System.Net.HttpStatusCode.ExpectationFailed);
        }

        public static async Task<HttpResponseMessage> ApiDelete(string url)
        {
            try
            {
                var jsonContentType = new MediaTypeWithQualityHeaderValue(@"application/json");
                var ts = new TimeSpan(0, 2, 0);

                using (HttpClient clientDelete = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts })
                {
                    clientDelete.DefaultRequestHeaders.Accept.Add(jsonContentType);

                    var sessionInfo = getSessionInfo();

                    if (!string.IsNullOrEmpty(sessionInfo))
                    {
                        clientDelete.DefaultRequestHeaders.Remove(nameof(UserDetailsModel));
                        clientDelete.DefaultRequestHeaders.Add(nameof(UserDetailsModel), sessionInfo);
                    }
                    var VisitorIp = GetClientIp();
                    if (!string.IsNullOrEmpty(VisitorIp))
                    {
                        clientDelete.DefaultRequestHeaders.Remove(nameof(VisitorIp));
                        clientDelete.DefaultRequestHeaders.Add(nameof(VisitorIp), VisitorIp);
                    }

                    requestsCount++;
                    var response = clientDelete.DeleteAsync(url);
                    requestsCount--;

                    return response.Result;
                }
            }
            catch (TaskCanceledException ex)
            {
                Log4NetLogger.LogEntry(ex.Message, string.Format("RestHelper | {0} occured for Delete on {1}", nameof(TaskCanceledException), url), ex.Message);
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry(ex.Message, string.Format("RestHelper | {0} occured for Delete on {1}", nameof(Exception), url), ex.Message);
            }

            return new HttpResponseMessage(System.Net.HttpStatusCode.NotAcceptable);

        }

        public static async Task<HttpResponseMessage> ApiPost(string url, dynamic data)
        {
            try
            {
                var jsonContentType = new MediaTypeWithQualityHeaderValue(@"application/json");
                var ts = new TimeSpan(0, 2, 0);

                using (HttpClient clientPost = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts })
                {
                    clientPost.DefaultRequestHeaders.Accept.Add(jsonContentType);

                    var request = HttpContext.Current.Request;
                    var sessionInfo = getSessionInfo();

                    //added for getting client machine IP
                    var VisitorIp = GetClientIp();
                    if (!string.IsNullOrEmpty(VisitorIp))
                    {
                        clientPost.DefaultRequestHeaders.Remove(nameof(VisitorIp));
                        clientPost.DefaultRequestHeaders.Add(nameof(VisitorIp), VisitorIp);
                    }
                    if (!string.IsNullOrEmpty(sessionInfo))
                    {
                        clientPost.DefaultRequestHeaders.Remove(nameof(UserDetailsModel));
                        clientPost.DefaultRequestHeaders.Add(nameof(UserDetailsModel), sessionInfo);
                    }

                    var bodyData = JSSerializerHelper.Serialize(data);

                    using (var stringContent = new StringContent(bodyData, Encoding.UTF8, @"application/json"))
                    {
                        requestsCount++;
                        var response = clientPost.PostAsync(url, stringContent);

                        requestsCount--;

                        return response.Result;
                    }
                }
            }
            catch (TaskCanceledException ex)
            {
                Log4NetLogger.LogEntry(ex.Message, string.Format("RestHelper | {0} occured for Post on {1}", nameof(TaskCanceledException), url), ex.Message);
            }
            catch (ArgumentException exe)
            {
                Log4NetLogger.LogEntry(exe.Message, string.Format("RestHelper | {0} occured for Post on {1}", nameof(ArgumentException), url), exe.Message);
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry(ex.Message, string.Format("RestHelper | {0} occured for Post on {1}", nameof(Exception), url), ex.Message);
            }

            return new HttpResponseMessage(System.Net.HttpStatusCode.ProxyAuthenticationRequired);

        }

        public static async Task<HttpResponseMessage> ApiPut(string url, dynamic data)
        {
            try
            {
                var jsonContentType = new MediaTypeWithQualityHeaderValue(@"application/json");
                var ts = new TimeSpan(0, 2, 0);

                using (HttpClient clientPut = new HttpClient { BaseAddress = new Uri(baseUri), Timeout = ts })
                {
                    clientPut.DefaultRequestHeaders.Accept.Add(jsonContentType);
                    var sessionInfo = getSessionInfo();
                    if (!string.IsNullOrEmpty(sessionInfo))
                    {
                        clientPut.DefaultRequestHeaders.Remove(nameof(UserDetailsModel));
                        clientPut.DefaultRequestHeaders.Add(nameof(UserDetailsModel), sessionInfo);
                    }
                    var VisitorIp = GetClientIp();
                    if (!string.IsNullOrEmpty(VisitorIp))
                    {
                        clientPut.DefaultRequestHeaders.Remove(nameof(VisitorIp));
                        clientPut.DefaultRequestHeaders.Add(nameof(VisitorIp), VisitorIp);
                    }
                    var bodyData = JSSerializerHelper.Serialize(data);

                    using (var stringContent = new StringContent(bodyData, Encoding.UTF8, @"application/json"))
                    {
                        requestsCount++;
                        var response = clientPut.PutAsync(url, stringContent);

                        requestsCount--;
                        return response.Result;
                    }
                }
            }
            catch (TaskCanceledException ex)
            {
                Log4NetLogger.LogEntry(ex.Message, string.Format("RestHelper | {0} occured for Put on {1}", nameof(TaskCanceledException), url), ex.Message);
            }
            catch (ArgumentException exe)
            {
                Log4NetLogger.LogEntry(exe.Message, string.Format("RestHelper | {0} occured for Put on {1}", nameof(ArgumentException), url), exe.Message);
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry(ex.Message, string.Format("RestHelper | {0} occured for Put on {1}", nameof(Exception), url), ex.Message);
            }

            return new HttpResponseMessage(System.Net.HttpStatusCode.PaymentRequired);

        }
       
        public static string GetClientIp()
        {        
            var context = HttpContext.Current;
            var clientIPAddr= context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(clientIPAddr))
            {
                return context.Request.ServerVariables["REMOTE_ADDR"];
            }
            else
            {
                var ipArray = clientIPAddr.Split(new Char[] { ',' });
                return ipArray[0];
            }
        }
    }
}