
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;
using CP.UETrack.Model.BEMS.AssetRegister;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class CurrentMaintenanceBAL : ICurrentMaintenanceBAL
    {
        private string _FileName = nameof(CurrentMaintenanceBAL);
        ICurrentMaintenanceDAL _CurrentMaintenaceDAL;
        public CurrentMaintenanceBAL(ICurrentMaintenanceDAL currentMaintenanceDAL)
        {
            _CurrentMaintenaceDAL = currentMaintenanceDAL;
        }
        public CurrentMaintenance Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CurrentMaintenaceDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
