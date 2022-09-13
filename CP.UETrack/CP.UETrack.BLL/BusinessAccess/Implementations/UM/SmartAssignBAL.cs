using CP.UETrack.BLL.BusinessAccess.Contracts.UM;
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.UM;
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.UM
{
    public class SmartAssignBAL: ISmartAssignBAL
    {
        private string _FileName = nameof(SmartAssignBAL);
        ISmartAssignDAL _SmartAssignDAL;
        public SmartAssignBAL(ISmartAssignDAL SmartAssignDAL)
        {
            _SmartAssignDAL = SmartAssignDAL;
        }

        public void RunSmartAssign()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(RunSmartAssign), Level.Info.ToString());
               _SmartAssignDAL.RunSmartAssign();
                Log4NetLogger.LogExit(_FileName, nameof(RunSmartAssign), Level.Info.ToString());
               
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

     

        public GridFilterResult SmartAssignGetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SmartAssignGetAll), Level.Info.ToString());
                var result = _SmartAssignDAL.SmartAssignGetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(SmartAssignGetAll), Level.Info.ToString());
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
        public GridFilterResult PorteringSmartAssignGetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SmartAssignGetAll), Level.Info.ToString());
                var result = _SmartAssignDAL.PorteringSmartAssignGetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(SmartAssignGetAll), Level.Info.ToString());
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
