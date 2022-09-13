using CP.UETrack.Model;

namespace CP.UETrack.DAL.DataAccess
{
    public interface IForgotPasswordDAL
    {
        //ForgotPasswordLovs Load();
        ForgotPassword Save(ForgotPassword forgotPassword, out string ErrorMessage);
        bool IsUsernameInValid(ForgotPassword forgotPassword);
        bool IsInvalidEmailId(ForgotPassword forgotPassword);
        //GridFilterResult GetAll(SortPaginateFilter pageFilter);
        //ForgotPassword Get(int Id);
        //void Delete(int Id);
    }
}