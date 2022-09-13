using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
   public interface IVehicleDetailsDAL
    {

        VehicleDetails Save(VehicleDetails block, out string ErrorMessage);

        VehicleDetailsDropdown Load();

        GridFilterResult GetAll(SortPaginateFilter pageFilter);

        VehicleDetails Get(int Id);        
        List<LicCodeDes> LicenseCodeFetch(LicCodeDes SearchObject);

        VehicleDetails DescriptionData(string LicenseCode);
    }
}
