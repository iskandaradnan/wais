using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IForgotPasswordBAL
    {
        //ForgotPasswordLovs Load();
        ForgotPassword Save(ForgotPassword forgotPassword, out string ErrorMessage);
        //GridFilterResult GetAll(SortPaginateFilter pageFilter);
        //ForgotPassword Get(int Id);
        //void Delete(int Id);
    }
}
