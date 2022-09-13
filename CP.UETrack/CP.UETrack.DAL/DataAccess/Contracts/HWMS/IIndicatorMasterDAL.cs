using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
   public interface IIndicatorMasterDAL
   {
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        IndicatorMaster Get(int Id);
        IndicatorMaster Save(IndicatorMaster block, out string ErrorMessage);

    }
}
