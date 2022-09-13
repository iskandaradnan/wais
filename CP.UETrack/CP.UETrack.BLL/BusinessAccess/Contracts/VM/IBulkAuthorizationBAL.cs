using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.VM
{
   public  interface IBulkAuthorizationBAL
    {
        BulkAuthorizationViewModel Load();
        BulkAuthorizationViewModel Get(int Year, int Month, int ServiceId, int PageSize, int PageIndex);
        BulkAuthorizationViewModel Save(BulkAuthorizationViewModel Cust, out string ErrorMessage);

    }
}
