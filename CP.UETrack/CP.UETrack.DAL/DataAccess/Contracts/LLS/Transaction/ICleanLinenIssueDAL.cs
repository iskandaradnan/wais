using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS
{
    public interface ICleanLinenIssueDAL
    {
        CleanLinenIssueModelLovs Load();
        CleanLinenIssueModel Save(CleanLinenIssueModel model, out string ErrorMessage);
        CleanLinenIssueModel GetByScheduledId(CleanLinenIssueModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CleanLinenIssueModel Get(int Id);
        CleanLinenIssueModel GetBY(CleanLinenIssueModel model);
        CleanLinenIssueModel GetByLinenItemDetails(int Id);
        CleanLinenIssueModel GetByLinenBagDetails(int Id);
       // CleanLinenIssueModel GetBY(int Id);
        bool IsCleanLinenIssueDuplicate(CleanLinenIssueModel model);
        bool IsRecordModified(CleanLinenIssueModel model);
        void Delete(int Id, out string ErrorMessage);
    }
}
