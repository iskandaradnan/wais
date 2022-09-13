using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface IDriverDetailsDAL
    {

        DriverDetails Save(DriverDetails block, out string ErrorMessage);

        DriverDetailsDropdownList Load();

        GridFilterResult GetAll(SortPaginateFilter pageFilter);

        DriverDetails Get(int Id);       
       
        DriverDetails DescriptionData(string LicenseCode);

        List<LicCodeDes> LicenseCodeFetch(LicCodeDes SearchObject);

    }
}
