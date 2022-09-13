using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using System.Web.Http;

namespace UETrack.Application.Web.API
{
    [RoutePrefix("api/AuthorizationService")]
    public class AuthorizationServiceApiController : BaseApiController
    {
        [HttpGet]
        [Route("GetUserRoleData/{UserName}")]        
        public AuthenticatedUser GetUserRoleData(string UserName)
        {
            UserName = UserName.Replace('☺', '.');
            
            return new AuthenticatedUser();

        }

    }
}
