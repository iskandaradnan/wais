using CP.UETrack.Model;
using CP.UETrack.Model.CLS;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
    public interface IFETCDAL
    {
        FETCDropdown Load();
        FETC Save(FETC block, out string ErrorMessage);

        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        FETC Get(int Id);
        FETC AutoGenerateCode();
    }
}

