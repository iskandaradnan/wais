using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.KPI
{
    public interface IMonthlyServiceFeeBAL
    {
        MonthlyServiceFeeTypeDropdown Load();
        MonthlyServiceFeeModel Save(MonthlyServiceFeeModel ServiceFee, out string ErrorMessage);
        MonthlyServiceFeeModel Get(int Id);
        MonthlyServiceFeeModel GetRevision(int Id, int Year);
        MonthlyServiceFeeModel GetVersion(int Year);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
    }
}
