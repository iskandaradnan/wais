using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IFacilityWorkshopBAL
    {
        FacilityWorkshopDropdown Load();
        FacilityWorkshop Save(FacilityWorkshop WarrantyProvider, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        FacilityWorkshop Get(int Id, int pagesize, int pageindex);
        //bool IsRoleDuplicate(AssetRegisterWarrantyProvider WarrantyProvider);
        //bool IsRecordModified(AssetRegisterWarrantyProvider WarrantyProvider);
        bool Delete(int Id);
    }
}
