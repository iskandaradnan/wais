using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface IDeptAreaDetailDAL
    {
        DeptAreaDetails Save(DeptAreaDetails block, out string ErrorMessage);
        DeptAreaDetailsDropdownList Load();
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DeptAreaDetails Get(int Id);
        DeptAreaDetails UserAreaNameData(string UserAreaCode);
        List<ItemTable> ItemCodeFetch(ItemTable SearchObject);
    }
}


