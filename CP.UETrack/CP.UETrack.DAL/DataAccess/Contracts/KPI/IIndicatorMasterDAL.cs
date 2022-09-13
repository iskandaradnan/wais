using System;
using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.KPI
{
   public interface IIndicatorMasterDAL
    {
        IndicatorTypeDropdown Load();
        IndicatorMasterModel Save(IndicatorMasterModel Indicator);

        IndicatorMasterModel Get(int Id);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        bool IsRecordModified(IndicatorMasterModel Indicator);
        bool IsIndicatorMasterCodeDuplicate(IndicatorMasterModel Indicator);
    }
}
