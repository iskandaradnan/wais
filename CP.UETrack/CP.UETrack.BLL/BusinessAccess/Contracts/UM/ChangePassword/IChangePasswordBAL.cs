using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IChangePasswordBAL
    {
        ChangePasswordLovs Load();
        ChangePassword IsAuthenticated(ChangePassword changePassword);
        ChangePassword Save(ChangePassword changePassword, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ChangePassword Get(int Id);
        void Delete(int Id);
    }
}
