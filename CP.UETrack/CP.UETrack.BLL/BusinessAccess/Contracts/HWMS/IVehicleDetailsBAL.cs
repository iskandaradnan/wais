using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{ 

   public interface IVehicleDetailsBAL
    {
        VehicleDetails Save(VehicleDetails userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        VehicleDetails Get(int Id);       
        List<LicCodeDes> LicenseCodeFetch(LicCodeDes SearchObject);      
        VehicleDetails DescriptionData(string LicenseCode);
        VehicleDetailsDropdown Load();
    }
}
