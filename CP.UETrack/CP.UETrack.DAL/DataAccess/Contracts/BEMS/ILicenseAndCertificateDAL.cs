using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
   public interface ILicenseAndCertificateDAL
    {
        void save(ref LicenseAndCertificateEntity entity);
        LCDropdownentity Load();
        void update(ref LicenseAndCertificateEntity model);
        LicenseAndCertificateEntity Get(int id, int pagesize, int pageindex);
        GridFilterResult Getall(SortPaginateFilter pageFilter);
        bool Delete(int id);
    }
}
