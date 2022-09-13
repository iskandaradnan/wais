using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS
{
    public interface ICentralLinenStoreHKeepingDAL
    {
        CentralLinenStoreHousekeepingModelLovs Load();
        CentralLinenStoreHousekeepingModel Save(CentralLinenStoreHousekeepingModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CentralLinenStoreHousekeepingModel Get(int Id);
        CentralLinenStoreHousekeepingModel HKeeping(int StoreType, int Year, int Month,int pagesize, int pageindex);
        bool IsCentralLinenStoreHKeepingDuplicate(CentralLinenStoreHousekeepingModel model);
        bool IsRecordModified(CentralLinenStoreHousekeepingModel model);
        void Delete(int Id, out string ErrorMessage);
    }
}