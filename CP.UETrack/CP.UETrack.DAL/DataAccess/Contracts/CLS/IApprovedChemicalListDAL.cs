using CP.UETrack.Model;
using CP.UETrack.Model.CLS;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
    public interface IApprovedChemicalListDAL
    {
        ApprovedChemicalListDropdown Load();
        ApprovedChemicalList Save(ApprovedChemicalList block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ApprovedChemicalList Get(int Id);
    }
}
