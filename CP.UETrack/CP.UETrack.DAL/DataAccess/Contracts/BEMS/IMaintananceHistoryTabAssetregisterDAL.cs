using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
  public  interface IMaintananceHistoryTabAssetregisterDAL
    {
        MaintenanceHistoryModelList fetchMaitenanceDetails(MaitenaceDetailsTab entity);
    }
}
