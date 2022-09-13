using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
   public interface ICollectionCategoryDAL
   {
        CollectionCategoryDropDown Load();
        CollectionCategory Save(CollectionCategory block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CollectionCategory Get(int Id);
        List<DeptAreaDetails> UserAreaCodeFetch(DeptAreaDetails SearchObject);
        CollectionCategory UserAreaNameData(string UserAreaCode); 
    }
}
