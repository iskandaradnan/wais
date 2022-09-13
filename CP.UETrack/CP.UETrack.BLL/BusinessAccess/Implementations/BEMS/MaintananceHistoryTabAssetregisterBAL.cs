using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class MaintananceHistoryTabAssetregisterBAL : IMaintananceHistoryTabAssetregisterBAL
    {
        private readonly IMaintananceHistoryTabAssetregisterDAL _DAL;
        private readonly static string fileName = nameof(AssetClassificationBAL);
        public MaintananceHistoryTabAssetregisterBAL(IMaintananceHistoryTabAssetregisterDAL DAL)
        {
            _DAL = DAL;
        }
        public MaintenanceHistoryModelList fetchMaitenanceDetails(MaitenaceDetailsTab entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(fetchMaitenanceDetails), Level.Info.ToString());
                var result = _DAL.fetchMaitenanceDetails(entity);
                Log4NetLogger.LogExit(fileName, nameof(fetchMaitenanceDetails), Level.Info.ToString());
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
