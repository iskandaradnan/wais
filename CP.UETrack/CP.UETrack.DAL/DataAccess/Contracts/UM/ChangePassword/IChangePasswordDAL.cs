using CP.UETrack.Model;

namespace CP.UETrack.DAL.DataAccess
{
    public interface IChangePasswordDAL
    {
        ChangePasswordLovs Load();
        ChangePassword IsAuthenticated(ChangePassword changePassword);
        ChangePassword Save(ChangePassword changePassword, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ChangePassword Get(int Id);
        void Delete(int Id);
        bool IsOldPasswordValid(ChangePassword changePassword);
    }
}