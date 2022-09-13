using CP.UETrack.Model;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface.LLS.Transaction
{
    public interface ICleanLinenIssueBAL
    {
        CleanLinenIssueModelLovs Load();
        CleanLinenIssueModel Save(CleanLinenIssueModel model, out string ErrorMessage);
        CleanLinenIssueModel GetByScheduledId(CleanLinenIssueModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CleanLinenIssueModel Get(int Id);
        CleanLinenIssueModel GetBY(CleanLinenIssueModel model);
        CleanLinenIssueModel GetByLinenItemDetails(int Id);
        CleanLinenIssueModel GetByLinenBagDetails(int Id);
       // CleanLinenIssueModel GetByScheduledId(int Id);
        void Delete(int Id, out string ErrorMessage);
    }

    
}
