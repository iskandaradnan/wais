using CP.UETrack.Model;
using CP.UETrack.Model.GM;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.GM
{
    public interface ILovMasterBAL
    {
        GridFilterResult GetAll(SortPaginateFilter PageFilter);
        LovMasterDropdownValues Load();
        LovMasterViewModel Get(string Id);
        LovMasterViewModel Save(LovMasterViewModel userRole, out string ErrorMessage);
    }
}

