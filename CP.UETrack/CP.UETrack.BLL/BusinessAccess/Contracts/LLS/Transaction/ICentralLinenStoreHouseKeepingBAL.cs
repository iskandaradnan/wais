using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction
{
   public interface ICentralLinenStoreHouseKeepingBAL
    {
        CentralLinenStoreHousekeepingModelLovs Load();
        CentralLinenStoreHousekeepingModel Save(CentralLinenStoreHousekeepingModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CentralLinenStoreHousekeepingModel HKeeping(int StoreType, int Year, int Month, int pagesize, int pageindex);
        CentralLinenStoreHousekeepingModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
