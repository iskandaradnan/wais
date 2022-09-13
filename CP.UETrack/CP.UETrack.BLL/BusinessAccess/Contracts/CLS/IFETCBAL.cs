using CP.UETrack.Model;
using CP.UETrack.Model.CLS;


namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
    public interface IFETCBAL
    {
        FETC Save(FETC userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        FETC Get(int Id);
        FETC AutoGenerateCode();
        FETCDropdown Load();
    }
}
