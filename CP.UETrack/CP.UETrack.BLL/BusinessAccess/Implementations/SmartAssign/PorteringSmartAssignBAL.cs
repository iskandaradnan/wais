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
using CP.UETrack.BLL.BusinessAccess.Contracts.SmartAssign;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.SmartAssign
{
    public class PorteringSmartAssignBAL : IPorteringSmartAssignBAL
    {

        private string _FileName = nameof(PorteringSmartAssignBAL);
        IPorteringSmartAssignBAL _SmartAssignDAL;
        public PorteringSmartAssignBAL(IPorteringSmartAssignBAL SmartAssignDAL)
        {
            _SmartAssignDAL = SmartAssignDAL;
        }


        public GridFilterResult PorteringSmartAssignGetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringSmartAssignGetAll), Level.Info.ToString());
                var result = _SmartAssignDAL.PorteringSmartAssignGetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(PorteringSmartAssignGetAll), Level.Info.ToString());
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
