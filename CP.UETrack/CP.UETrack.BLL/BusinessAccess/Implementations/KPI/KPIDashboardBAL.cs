using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.KPI;
using CP.UETrack.DAL.DataAccess.Contracts.KPI;
using CP.UETrack.Model.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.KPI
{
    public class KPIDashboardBAL: IKPIDashboardBAL
    {
        private string _FileName = nameof(KPIDashboardBAL);
        IKPIDashboardDAL _KPIDashboardDAL;

        public KPIDashboardBAL(IKPIDashboardDAL KPIDashboardDAL)
        {
            _KPIDashboardDAL = KPIDashboardDAL;
        }

        public KPIDashboardTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _KPIDashboardDAL.Load();
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

        public KPIDashboardModel Get(int Year)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _KPIDashboardDAL.Get(Year);
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

        public KPIDashboardModel GetDate(int Year,int Month)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDate), Level.Info.ToString());
                var result = _KPIDashboardDAL.GetDate(Year, Month);
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
