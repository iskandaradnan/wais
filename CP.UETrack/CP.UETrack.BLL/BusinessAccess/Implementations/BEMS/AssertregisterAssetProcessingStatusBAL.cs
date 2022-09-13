using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
   public class AssertregisterAssetProcessingStatusBAL : IAssertregisterAssetProcessingStatusBAL
    {



        private readonly IAssertregisterAssetProcessingStatusDAL _IAssertregisterAssetProcessingStatusDAL;
        private readonly static string fileName = nameof(AssetClassificationBAL);
        public AssertregisterAssetProcessingStatusBAL(IAssertregisterAssetProcessingStatusDAL IAssertregisterAssetProcessingStatusDAL)
        {
            _IAssertregisterAssetProcessingStatusDAL = IAssertregisterAssetProcessingStatusDAL;

        }

        public List<AssetProcessingStatus> AssetProcessingStatus(AssetProcessingStatus entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(AssetProcessingStatus), Level.Info.ToString());
                var result = _IAssertregisterAssetProcessingStatusDAL.AssetProcessingStatus(entity);
                Log4NetLogger.LogExit(fileName, nameof(AssetProcessingStatus), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }







    }
}
