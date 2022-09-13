using FluentValidation;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System.Text.RegularExpressions;

namespace CP.UETrack.BLL.BusinessAccess.BusinessValidation
{
    public class AuthorizationValidator : ValidatorBase<AuthUser>
    {
        private readonly IAuthorizationDAL _authDalValue;

        public AuthorizationValidator(IAuthorizationDAL authDal)
        {
            _authDalValue = authDal;


            RuleSet("AuthValidation", () =>
            {
                RuleFor(auth => auth.Username)
                 .Cascade(CascadeMode.StopOnFirstFailure)
                 .NotNull()
                 .NotEmpty()
                 .WithMessage("User ID is required.");
            });

        }
        
    }
}