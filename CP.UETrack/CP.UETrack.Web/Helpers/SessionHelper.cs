using CP.UETrack.Model;
using CP.Framework.Common.StateManagement;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace UETrack.Application.Web.Helpers
{
    public class SessionHelper : ISessionHelper
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public UserDetailsModel UserSession()
        {
            var userDetail = new UserDetailsModel();

            var context = HttpContext.Current;

            var reqHeaders = context.Request.Headers;
            var userinfo = reqHeaders.GetValues(nameof(UserDetailsModel));

            if (userinfo != null)
            {
                var jss = new JavaScriptSerializer();
                userDetail = jss.Deserialize<UserDetailsModel>(userinfo.FirstOrDefault());
            }
            else
            {
                userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            }

            if (userDetail == null)
            {
                context.Response.Redirect("~/Account/Login?r=sto", true);
                return null;
            }
            else
            {
                return userDetail;
            }

        }
        public bool IsSessionExists()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            return (userDetail != null);
        }

        public void Clear(string key)
        {
            _sessionProvider.Clear(key);
        }

        public object Get(string key)
        {
            return _sessionProvider.Get(key);
        }

        public void Set(string key, object value)
        {
            _sessionProvider.Set(key, value);
        }

    }

    public interface ISessionHelper
    {
        void Clear(string key);
        object Get(string key);
        void Set(string key, object value);

    }
}