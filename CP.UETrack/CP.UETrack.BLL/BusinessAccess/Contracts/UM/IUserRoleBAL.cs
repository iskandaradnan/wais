using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IUserRoleBAL
    {
        UserRoleLovs Load();
        UMUserRole Save(UMUserRole userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        UMUserRole Get(int Id);
        void Delete(int Id, out string ErrorMessage);
        GridFilterResult Export(SortPaginateFilter pageFilter, string ExportType);
    }
}
