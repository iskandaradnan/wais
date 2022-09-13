using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.VM
{
    public class VMDashboardBAL:IVMDashboardBAL
    {
        private string _FileName = nameof(VMDashboardBAL);
        IVMDashboardDAL _VMDashboardDAL;

        public VMDashboardBAL(IVMDashboardDAL VMDashboardDAL)
        {
            _VMDashboardDAL = VMDashboardDAL;
        }

        public VMDashboardTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _VMDashboardDAL.Load();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
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

        public VMDashboardModel Get(int Year)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _VMDashboardDAL.Get(Year);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public VMDashboardModel GetDate(int Year, int Month)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDate), Level.Info.ToString());
                var result = _VMDashboardDAL.GetDate(Year, Month);
                Log4NetLogger.LogExit(_FileName, nameof(GetDate), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
    }
}
