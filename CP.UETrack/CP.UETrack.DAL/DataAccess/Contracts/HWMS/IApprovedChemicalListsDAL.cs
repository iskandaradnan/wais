using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
   public interface IApprovedChemicalListsDAL
    {
        ApprovedChemicalListsDropdown Load();
        ApprovedChemicalLists Save(ApprovedChemicalLists block, out string ErrorMessage);

        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        ApprovedChemicalLists Get(int Id);
    }
}
