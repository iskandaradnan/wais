
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class MonthlyKPIAdjustmentsBAL : IMonthlyKPIAdjustmentsBAL
    {
        private string _FileName = nameof(MonthlyKPIAdjustmentsBAL);
        IMonthlyKPIAdjustmentsDAL _MonthlyKPIAdjustmentsDAL;

        public MonthlyKPIAdjustmentsBAL(IMonthlyKPIAdjustmentsDAL monthlyKPIAdjustmentsDAL)
        {
            _MonthlyKPIAdjustmentsDAL = monthlyKPIAdjustmentsDAL;
        }
        public MonthlyKPIAdjustmentsLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _MonthlyKPIAdjustmentsDAL.Load();
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
        public MonthlyKPIAdjustments Save(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                MonthlyKPIAdjustments result = null;

                if (IsValid(monthlyKPIAdjustments, out ErrorMessage))
                {
                    result = _MonthlyKPIAdjustmentsDAL.Save(monthlyKPIAdjustments, out ErrorMessage);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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
        public List<MonthlyKPIAdjustmentFetchResult> FetchRecords(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                var result = _MonthlyKPIAdjustmentsDAL.FetchRecords(monthlyKPIAdjustments, out ErrorMessage);

                Log4NetLogger.LogExit(_FileName, nameof(FetchRecords), Level.Info.ToString());
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
        private bool IsValid(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = true;
            return isValid;
        }
        public List<KPIGenerationDemertis> GetPostDemeritPoints(KPIGenerationFetch kpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetPostDemeritPoints), Level.Info.ToString());
                var result = _MonthlyKPIAdjustmentsDAL.GetPostDemeritPoints(kpiGenerationFetch);
                Log4NetLogger.LogExit(_FileName, nameof(GetPostDemeritPoints), Level.Info.ToString());
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
