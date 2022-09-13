using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{

    public interface IDeptAreaDetail
    {
        DeptAreaDetails Save(DeptAreaDetails userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DeptAreaDetails Get(int Id);
        DeptAreaDetails UserAreaNameData(string UserAreaCode);
        List<ItemTable> ItemCodeFetch(ItemTable SearchObject);
        DeptAreaDetailsDropdownList Load();
    }
}
