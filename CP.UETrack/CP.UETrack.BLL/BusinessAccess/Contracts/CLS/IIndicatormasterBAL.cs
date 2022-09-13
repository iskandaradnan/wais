using CP.UETrack.Model.CLS;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
 
    public interface IIndicatorMasterBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        IndicatorMaster Get(int Id);
        IndicatorMaster Save(IndicatorMaster userRole, out string ErrorMessage);
    }
}
