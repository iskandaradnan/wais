using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.QAP;
using CP.UETrack.DAL.DataAccess.Contracts.QAP;
using CP.UETrack.Model.QAP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.QAP
{
    public class QAPDashboardBAL : IQAPDashboardBAL
    {
        private string _FileName = nameof(QAPDashboardBAL);
        IQAPDashboardDAL _QAPDashboardDAL;

        public QAPDashboardBAL(IQAPDashboardDAL QAPDashboardDAL)
        {
            _QAPDashboardDAL = QAPDashboardDAL;
        }

        public QAPDashboardTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _QAPDashboardDAL.Load();
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

        public QAPDashboardModel Get(int Year)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _QAPDashboardDAL.Get(Year);
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

        public QAPDashboardModel GetLineChart(int Month)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetLineChart), Level.Info.ToString());
                var result = _QAPDashboardDAL.GetLineChart(Month);
                Log4NetLogger.LogExit(_FileName, nameof(GetLineChart), Level.Info.ToString());
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
