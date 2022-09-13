using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IAuthorizationBAL
    {
        AuthUser GetDatabaseUserRolesPermissions(AuthUser authuser);
        AuthenticatedUser GetDatabaseUserRolesPermissions(AuthenticatedUser authuser);

    }
}
