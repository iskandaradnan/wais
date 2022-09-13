using CP.UETrack.DAL.DataAccess.Implementations.LLS.Transaction;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction
{
    public interface ILinenInventoryDAL
    {
        LinenInventoryModelClassLovs Load();
        TestModel Save(TestModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        TestModel Get(int Id);

        bool IsLinenAdjustmentDuplicate(TestModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}