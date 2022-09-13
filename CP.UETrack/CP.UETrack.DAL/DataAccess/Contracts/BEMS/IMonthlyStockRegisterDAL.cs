using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IMonthlyStockRegisterDAL
    {
        MonthlyStockRegisterTypeDropdown Load();
        MonthlyStockRegisterModel Save(MonthlyStockRegisterModel MonthlyStock);

        MonthlyStockRegisterModel Get(MonthlyStockRegisterModel MonthlyStock);
        MonthlyStockRegisterModel GetModal(ItemMonthlyStockRegisterModal MonthlyReg);
        bool Delete(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        bool IsRecordModified(MonthlyStockRegisterModel MonthlyStock);
        bool IsMonthlyStockRegisterCodeDuplicate(MonthlyStockRegisterModel MonthlyStock);
    }
}
