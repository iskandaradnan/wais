using System;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contract;
using CP.UETrack.DAL.DataAccess.Contracts.Common;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Implementation
{
    /// <summary>
    /// Common BAL Holds implementaions for common functinalities acrss the application
    /// </summary>
    public class ReportCommonBAL : IReportCommonBAL
    {
        readonly IReportCommonDAL _commonDAL;

        readonly string fileName = nameof(ReportCommonBAL);

        public ReportCommonBAL(IReportCommonDAL CommonDAL)
        {
            _commonDAL = CommonDAL;

        }

        public dynamic GetReportData(string whereCondition, string viewModelName)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetReportData), Level.Info.ToString());
                var result = _commonDAL.GetReportData(whereCondition, viewModelName);
                Log4NetLogger.LogExit(fileName, nameof(GetReportData), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        public string GetReportDataSet(string spName, Dictionary<string, string> parameters)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetReportDataSet), Level.Info.ToString());
                var result = _commonDAL.GetReportDataSet(spName, parameters);
                Log4NetLogger.LogExit(fileName, nameof(GetReportDataSet), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
    }
}
