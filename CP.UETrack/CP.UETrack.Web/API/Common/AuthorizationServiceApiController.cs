using CP.ASIS.Application.Web.API;
using CP.ASIS.BLL.BusinessAccess;
using CP.ASIS.BLL.BusinessAccess.BusinessValidation;
using CP.ASIS.DAL.DataAccess;
using CP.ASIS.Model;
using CP.ASIS.Service;

namespace ASIS.Application.Web.API
{
    [System.Web.Http.RoutePrefix("api/AuthorizationService")]
    public class AuthorizationServiceApiController : BaseApiController
    {
        [System.Web.Http.HttpGet("GetUserRoleData/{UserName}")]
        public AuthenticatedUser GetUserRoleData(string UserName)
        {
            var authService = new AuthorizationService(new AuthorizationBAL(new AuthorizationDAL(), new AuthorizationValidator(new AuthorizationDAL())));

            return authService.GetDatabaseUserRolesPermissions(UserName);

        }

    }
}
