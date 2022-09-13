using CP.UETrack.Model;
using CP.Framework.Common.StateManagement;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace CP.UETrack.DAL.DataAccess
{
    public class SessionHelper : ISessionHelper
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public UserDetailsModel UserSession()
        {
            var USession = new UserDetailsModel();

            var context = HttpContext.Current;
            var reqHeaders = context.Request.Headers;
            var userinfo = reqHeaders.GetValues(nameof(UserDetailsModel));
            if (userinfo != null)
            {
                var jss = new JavaScriptSerializer();
                USession = jss.Deserialize<UserDetailsModel>(userinfo.FirstOrDefault());
            }
          
            return (USession != null) ? USession : null;

        }
    }
    public interface ISessionHelper
    {
        UserDetailsModel UserSession();
    }
}