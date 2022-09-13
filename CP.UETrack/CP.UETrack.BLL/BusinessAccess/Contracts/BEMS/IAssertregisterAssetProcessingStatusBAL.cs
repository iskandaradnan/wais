using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
   public interface IAssertregisterAssetProcessingStatusBAL
    {

        List<AssetProcessingStatus> AssetProcessingStatus(AssetProcessingStatus entity);
    }
}
