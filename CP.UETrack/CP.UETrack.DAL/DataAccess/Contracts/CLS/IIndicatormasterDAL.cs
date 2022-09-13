using CP.UETrack.Model;
using CP.UETrack.Model.CLS;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
   public interface IIndicatorMasterDAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        IndicatorMaster Get(int Id);
        IndicatorMaster Save(IndicatorMaster block, out string ErrorMessage);

    }
}
