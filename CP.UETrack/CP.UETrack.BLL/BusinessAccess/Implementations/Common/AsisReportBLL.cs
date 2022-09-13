using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess.Implementations.Common;
using CP.UETrack.Model.Common;
using System;
using System.Collections.Generic;
using System.Data;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.Common
{
    public class AsisReportBLL : IAsisReportBLL
    {
        private string _FileName = nameof(AsisReportBLL);
        IAsisReportDAL _AsisReportDAL;

        public AsisReportBLL(IAsisReportDAL AsisReportDAL)
        {
            _AsisReportDAL = AsisReportDAL;
        }

        public AsisReportViewModel ExecuteDataSet(AsisReportViewModel rVM)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ExecuteDataSet), Level.Info.ToString());
                var result = _AsisReportDAL.ExecuteDataSet(rVM);
                Log4NetLogger.LogExit(_FileName, nameof(ExecuteDataSet), Level.Info.ToString());
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

        public AsisReportViewModel GetDataTableForDdl(AsisReportViewModel rVM)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDataTableForDdl), Level.Info.ToString());
                var result = _AsisReportDAL.GetDataTableForDdl(rVM);
                Log4NetLogger.LogExit(_FileName, nameof(GetDataTableForDdl), Level.Info.ToString());
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

        public AsisReportViewModel GetSqlParmsList(AsisReportViewModel rVM)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetSqlParmsList), Level.Info.ToString());
                var result = _AsisReportDAL.GetSqlParmsList(rVM);
                Log4NetLogger.LogExit(_FileName, nameof(GetSqlParmsList), Level.Info.ToString());
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
