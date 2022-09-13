
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class ReportsAndRecordsBAL : IReportsAndRecordsBAL
    {
        private string _FileName = nameof(ReportsAndRecordsBAL);
        IReportsAndRecordsDAL _ReportsAndRecordsDAL;

        public ReportsAndRecordsBAL(IReportsAndRecordsDAL reportsAndRecordsDAL)
        {
            _ReportsAndRecordsDAL = reportsAndRecordsDAL;
        }
        public ReportsAndRecordsLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _ReportsAndRecordsDAL.Load();
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
        public ReportsAndRecordsLst FetchRecords(int Year, int Month)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _ReportsAndRecordsDAL.FetchRecords(Year, Month);
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
        public ReportsAndRecordsLst Save(ReportsAndRecordsLst repotsAndRecordsList, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                ReportsAndRecordsLst result = null;

                result = _ReportsAndRecordsDAL.Save(repotsAndRecordsList, out ErrorMessage);

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
        private bool IsValid(CorrectiveActionReport correctiveActionReport, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            var currentDate = DateTime.Now.Date;
            var errorMessage = string.Empty;

            if (correctiveActionReport.CARDate != null && correctiveActionReport.CARDate != DateTime.MinValue && correctiveActionReport.CARDate.Date > currentDate)
            {
                ErrorMessage = "CAR Date cannot be a future date";
            }
            else if (correctiveActionReport.FromDate != null && correctiveActionReport.FromDate != DateTime.MinValue && ((DateTime)correctiveActionReport.FromDate).Date > currentDate)
            {
                ErrorMessage = "CAR Period From Date cannot be a future date";
            }
            else if (correctiveActionReport.ToDate != null && correctiveActionReport.ToDate != DateTime.MinValue && ((DateTime)correctiveActionReport.ToDate).Date > currentDate)
            {
                ErrorMessage = "CAR Period To Date cannot be a future date";
            }
            else if (correctiveActionReport.ToDate != null && correctiveActionReport.ToDate != DateTime.MinValue &&
                (correctiveActionReport.FromDate == null || correctiveActionReport.FromDate == DateTime.MinValue))
            {
                ErrorMessage = "CAR Period From Date is mandatory when CAR Period To Date is entered";
            }
            else if (correctiveActionReport.FromDate != null && correctiveActionReport.FromDate != DateTime.MinValue
                && correctiveActionReport.ToDate != null && correctiveActionReport.ToDate != DateTime.MinValue
                && ((DateTime)correctiveActionReport.ToDate).Date < (DateTime)correctiveActionReport.FromDate)
            {
                ErrorMessage = "CAR Period To Date should be greater than or equal to CAR Period From Date";
            }
            else if (correctiveActionReport.VerifiedDate != null && correctiveActionReport.VerifiedDate != DateTime.MinValue && ((DateTime)correctiveActionReport.VerifiedDate).Date > currentDate)
            {
                ErrorMessage = "Verified Date cannot be a future date";
            }
            //else if (correctiveActionReport.CARDate != null && correctiveActionReport.FromDate != null && ((((DateTime)correctiveActionReport.FromDate).Date) < ((DateTime)correctiveActionReport.CARDate).Date))
            //{
            //    ErrorMessage = "CAR Period From Date should be greater than or equal to CAR Date";
            //}
            //else if (correctiveActionReport.CARDate != null && correctiveActionReport.ToDate != null && ((((DateTime)correctiveActionReport.ToDate).Date) < ((DateTime)correctiveActionReport.CARDate).Date))
            //{
            //    ErrorMessage = "CAR Period To Date should be greater than or equal to CAR Date";
            //}
            else if (correctiveActionReport.CARTargetDate < currentDate)
            {
                ErrorMessage = "CAR Target Date cannot be a past date";
            }
            else if (correctiveActionReport.CARDate != null && correctiveActionReport.VerifiedDate != null && ((((DateTime)correctiveActionReport.VerifiedDate).Date) < ((DateTime)correctiveActionReport.CARDate).Date))
            {
                ErrorMessage = "Verified Date should be greater than or equal to CAR Date";
            }
            else if (!IsGridValid(correctiveActionReport, out errorMessage))
            {
                ErrorMessage = errorMessage;
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        private bool IsGridValid(CorrectiveActionReport correctiveActionReport, out string ErrorMessage)
        {
            var isValid = true;
            ErrorMessage = "";
            var currentDate = DateTime.Now.Date;
            var carDate = correctiveActionReport.CARDate.Date;

            foreach (var item in correctiveActionReport.activities)
            {
                if (item.StartDate.Date < carDate)
                {
                    ErrorMessage = "Activity Start Date should be greater than or equal to CAR Date";
                    break;
                }
                if (item.StartDate.Date > currentDate)
                {
                    ErrorMessage = "Activity Start Date cannot be a future date";
                    break;
                }
                if (item.TargetDate < item.StartDate)
                {
                    ErrorMessage = "Activity Target Date should be greater than or equal to Activity Start Date";
                    break;
                }
                if (item.CompletedDate < item.StartDate)
                {
                    ErrorMessage = "Activity Actual Completion Date should be greater than or equal to Activity Start Date";
                    break;
                }
            }
            if (ErrorMessage != string.Empty)
            {
                isValid = false;
            }
            return isValid;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _ReportsAndRecordsDAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
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
        public ReportsAndRecordsLst Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _ReportsAndRecordsDAL.Get(Id);
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
        public CARWorkOrderList GetWorkOrderDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
                var result = _ReportsAndRecordsDAL.GetWorkOrderDetails(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
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
        public CARHistoryList GetCARHistoryDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetCARHistoryDetails), Level.Info.ToString());
                var result = _ReportsAndRecordsDAL.GetCARHistoryDetails(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetCARHistoryDetails), Level.Info.ToString());
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
        public CARWorkOrderList SaveWorkOrderDetails(CARWorkOrderList carWorkOrderList)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveWorkOrderDetails), Level.Info.ToString());
                var result = _ReportsAndRecordsDAL.SaveWorkOrderDetails(carWorkOrderList);
                Log4NetLogger.LogExit(_FileName, nameof(SaveWorkOrderDetails), Level.Info.ToString());
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _ReportsAndRecordsDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
        public RootCauseList GetRootCauses(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetRootCauses), Level.Info.ToString());
                var result = _ReportsAndRecordsDAL.GetRootCauses(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetRootCauses), Level.Info.ToString());
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
