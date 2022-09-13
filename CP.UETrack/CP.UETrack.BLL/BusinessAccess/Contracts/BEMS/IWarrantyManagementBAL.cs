using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IWarrantyManagementBAL
    {
        ServiceLov Load();
        WarrantyManagement Save(WarrantyManagement WarrantyProvider, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        WarrantyManagement Get(int Id);
        //bool IsRoleDuplicate(AssetRegisterWarrantyProvider WarrantyProvider);
        //bool IsRecordModified(AssetRegisterWarrantyProvider WarrantyProvider);
        bool Delete(int Id);

        WarrantyManagement GetDD(int Id , int pagesize, int pageindex);
        WarrantyManagement GetWO(int Id, int pagesize, int pageindex);
    }
}
