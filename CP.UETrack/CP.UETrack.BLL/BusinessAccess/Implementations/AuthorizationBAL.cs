using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class AuthorizationBAL : IAuthorizationBAL
    {
        private readonly IAuthorizationDAL _authDalValue;
        private readonly IValidator<AuthUser> _authValidator;

        #region "Public variable declaration"

        Log4NetLogger log = new Log4NetLogger();

        #endregion

        public AuthorizationBAL(IAuthorizationDAL authDal,
            IValidator<AuthUser> authValidator)
        {
            _authDalValue = authDal;

            _authValidator = authValidator;
        }
        
        public AuthUser GetDatabaseUserRolesPermissions(AuthUser authuser)
        {
            try
            {
                _authValidator.Validate(new ValidationContext<AuthUser>(authuser, new PropertyChain(), new RulesetValidatorSelector("AuthValidation")));
                return _authDalValue.GetDatabaseUserRolesPermissions(authuser);
            }
            catch (Exception ex)
            {
                log.LogMessage("An error has occured because of exception", Level.Info);
                throw new BALException(ex);
            }
        }

        public AuthenticatedUser GetDatabaseUserRolesPermissions(AuthenticatedUser authenticatedUser)
        {
            try
            {
                var authuser = new AuthUser { Username=authenticatedUser.Username };
                
                _authValidator.Validate(new ValidationContext<AuthUser>(authuser, 
                    new PropertyChain(), new RulesetValidatorSelector("AuthValidation")));

                return _authDalValue.GetDatabaseUserRolesPermissions(authenticatedUser);
            }
            catch (Exception ex)
            {
                log.LogMessage("An error has occured because of exception", Level.Info);
                throw new BALException(ex);
            }
        }
    }
}
