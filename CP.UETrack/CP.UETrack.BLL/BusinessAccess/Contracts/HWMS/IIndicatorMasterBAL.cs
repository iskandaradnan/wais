using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
   public interface IIndicatorMasterBAL
   {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        IndicatorMaster Get(int Id);
        IndicatorMaster Save(IndicatorMaster userRole, out string ErrorMessage);
    }
}
