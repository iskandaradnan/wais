using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IWarrantyManagementDAL
    {
        ServiceLov Load();
        WarrantyManagement Save(WarrantyManagement WarrantyMan);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        WarrantyManagement Get(int Id);
        //bool IsRoleDuplicate(WarrantyManagement Warranty);
        bool IsRecordModified(WarrantyManagement Warranty);
        bool Delete(int Id);

        WarrantyManagement GetDD(int Id, int pagesize, int pageindex);
        WarrantyManagement GetWO(int Id, int pagesize, int pageindex);
    }
}
