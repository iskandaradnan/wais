using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface IDriverDetailsBAL
    {
        DriverDetails Save(DriverDetails userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        DriverDetails Get(int Id);      
        DriverDetailsDropdownList Load();
        List<LicCodeDes> LicenseCodeFetch(LicCodeDes SearchObject);
        DriverDetails DescriptionData(string LicenseCode);
    }
}
