using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IAssertregisterAssetProcessingStatusDAL
    {

        List<AssetProcessingStatus> AssetProcessingStatus(AssetProcessingStatus entity);
    }
}
