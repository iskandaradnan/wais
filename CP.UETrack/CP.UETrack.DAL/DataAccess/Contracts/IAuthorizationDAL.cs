using CP.UETrack.Model;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IAuthorizationDAL
    {
        AuthUser GetDatabaseUserRolesPermissions(AuthUser authuser);
        AuthenticatedUser GetDatabaseUserRolesPermissions(AuthenticatedUser authenticatedUser);
    }
}


