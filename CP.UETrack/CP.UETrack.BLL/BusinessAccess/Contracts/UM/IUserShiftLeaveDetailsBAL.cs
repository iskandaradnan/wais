using CP.UETrack.Model;
using CP.UETrack.Model.UM;
namespace CP.UETrack.BLL.BusinessAccess.Contracts.UM
{
    public interface IUserShiftLeaveDetailsBAL
    {
        UserShiftLeaveDropdownValues Load();
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        UserShiftLeaveViewModel Get(int Id);
        UserShiftLeaveViewModel GetLeaveDetails(int Id);
        UserShiftLeaveViewModel Save(UserShiftLeaveViewModel userRole, out string ErrorMessage);
    }
}
