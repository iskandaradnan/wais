using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
   public interface ICollectionCategoryBAL
   {
        CollectionCategoryDropDown Load();
        CollectionCategory Save(CollectionCategory userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CollectionCategory Get(int Id);
        List<DeptAreaDetails> UserAreaCodeFetch(DeptAreaDetails SearchObject);
        CollectionCategory UserAreaNameData(string UserAreaCode);        

    }
}
