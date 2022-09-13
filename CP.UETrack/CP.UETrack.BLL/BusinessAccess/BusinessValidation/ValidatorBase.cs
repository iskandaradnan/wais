using FluentValidation;
using FluentValidation.Results;

namespace CP.UETrack.BLL.BusinessAccess.BusinessValidation
{
    public class ValidatorBase<T> : AbstractValidator<T>
    {
        public override ValidationResult Validate(ValidationContext<T> context)
        {
            var validationResult = base.Validate(context);
            if (!validationResult.IsValid)
                throw new ValidationException(validationResult.Errors);
            return validationResult;
        }
        public override ValidationResult Validate(T instance)
        {
            var validationResult = base.Validate(instance);
            if (!validationResult.IsValid)
                throw new ValidationException(validationResult.Errors);
            return validationResult;
        }
    }
}
