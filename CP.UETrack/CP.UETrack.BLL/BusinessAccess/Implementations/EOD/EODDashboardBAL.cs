using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class EODDashboardBAL : IEODDashboardBAL
    {
        private string _FileName = nameof(EODDashboardBAL);
        IEODDashboardDAL _EODDashboardDAL;
        public EODDashboardBAL(IEODDashboardDAL EODDashboardDAL)
        {
            _EODDashboardDAL = EODDashboardDAL;
        }
        public EODDashboardViewModel Load(int Year,int Month)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _EODDashboardDAL.Load(Year, Month);
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

        public EODDashboardViewModel getChartData(int NoofMonths, int FacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(getChartData), Level.Info.ToString());
                var result = _EODDashboardDAL.getChartData(NoofMonths, FacilityId);
                Log4NetLogger.LogExit(_FileName, nameof(getChartData), Level.Info.ToString());
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
