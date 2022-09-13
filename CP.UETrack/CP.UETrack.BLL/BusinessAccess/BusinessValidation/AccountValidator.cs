using FluentValidation;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System.Text.RegularExpressions;

namespace CP.UETrack.BLL.BusinessAccess.BusinessValidation
{
    public class AccountValidator : ValidatorBase<LoginViewModel>
    {
        private readonly IAccountDAL _accountDALValue;

        public AccountValidator(IAccountDAL accountDal)
        {
            _accountDALValue = accountDal;


            RuleSet("LoginValidation", () =>
            {
                RuleFor(account => account.LoginName)
                 .Cascade(CascadeMode.StopOnFirstFailure)
                 .NotNull()
                 .NotEmpty()
                 .WithMessage("Login ID is required.");

                RuleFor(account => account.Password)
                 .Cascade(CascadeMode.StopOnFirstFailure)
                 .NotNull()
                 .NotEmpty()
                 .WithMessage("Password is required.");
            });

        }
        
    }
}