
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class TestingAndCommissioningBAL : ITestingAndCommissioningBAL
    {
        private string _FileName = nameof(TestingAndCommissioningBAL);
        ITestingAndCommissioningDAL _TestingAndCommissioningDAL;

        public TestingAndCommissioningBAL(ITestingAndCommissioningDAL testingAndCommissioningDAL)
        {
            _TestingAndCommissioningDAL = testingAndCommissioningDAL;
        }
        public TestingAndCommissioningLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _TestingAndCommissioningDAL.Load();
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
        public TestingAndCommissioning Save(TestingAndCommissioning testingAndCommissioning, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                TestingAndCommissioning result = null;

                if (IsValid(testingAndCommissioning, out ErrorMessage))
                {
                    result = _TestingAndCommissioningDAL.Save(testingAndCommissioning, out ErrorMessage);
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
        public TAndCSNF SaveSNF(TAndCSNF testingAndCommissioning, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                TAndCSNF result = null;

                if (IsValidSNF(testingAndCommissioning, out ErrorMessage))
                {
                    result = _TestingAndCommissioningDAL.SaveSNF(testingAndCommissioning, out ErrorMessage);
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
        private bool IsValidSNF(TAndCSNF testingAndCommissioning, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            var currentDate = DateTime.Now.Date;

            if (testingAndCommissioning.ServiceStartDate < ((DateTime)testingAndCommissioning.TandCCompletedDate).Date)
            {
                ErrorMessage = "Service Start Date should be greater than or equal to T&C Completed Date";
            }
            else if (testingAndCommissioning.ServiceEndDate != DateTime.MinValue && testingAndCommissioning.ServiceEndDate < ((DateTime)testingAndCommissioning.TandCCompletedDate).Date)
            {
                ErrorMessage = "Service Stop Date should be greater than or equal to T&C Completed Date";
            }
            else if (testingAndCommissioning.ServiceEndDate != DateTime.MinValue && testingAndCommissioning.ServiceEndDate < testingAndCommissioning.ServiceStartDate)
            {
                ErrorMessage = "Service Stop Date should be greater than or equal to Service Start Date";
            }
            else if (testingAndCommissioning.PurchaseDate != null && testingAndCommissioning.PurchaseDate != DateTime.MinValue
                && ((DateTime)testingAndCommissioning.PurchaseDate).Date > currentDate)
            {
                ErrorMessage = "Purchase Date cannot be a future date";
            }
            else if (testingAndCommissioning.ServiceStartDate != null && testingAndCommissioning.ServiceStartDate != DateTime.MinValue
                && ((DateTime)testingAndCommissioning.ServiceStartDate).Date > currentDate)
            {
                ErrorMessage = "Service Start Date cannot be a future date";
            }
            else if (testingAndCommissioning.ServiceEndDate != null && testingAndCommissioning.ServiceEndDate != DateTime.MinValue
                && ((DateTime)testingAndCommissioning.ServiceEndDate).Date > currentDate)
            {
                ErrorMessage = "Service Stop Date cannot be a future date";
            }
            //else if (testingAndCommissioning.WarrantyStartDate != null && testingAndCommissioning.WarrantyStartDate != DateTime.MinValue
            //   && ((DateTime)testingAndCommissioning.WarrantyStartDate).Date > currentDate)
            //{
            //    ErrorMessage = "Warranty Start Date cannot be a future date";
            //}
            else
            {
                isValid = true;
            }
            return isValid;
        }
        private bool IsValid(TestingAndCommissioning testingAndCommissioning, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            var currentDate = DateTime.Now.Date;
            if (!string.IsNullOrEmpty(testingAndCommissioning.SerialNo) && _TestingAndCommissioningDAL.IsSerialNoDuplicate(testingAndCommissioning))
            {
                ErrorMessage = "Serial No. should be unique";
            }
            else if (testingAndCommissioning.TandCDate != DateTime.MinValue && testingAndCommissioning.TandCDate.Date > currentDate)
            {
                ErrorMessage = "T&C Date cannot be a future date";
            }
            else if (testingAndCommissioning.RequestDate != null && testingAndCommissioning.RequestDate > testingAndCommissioning.TandCDate)
            {
                ErrorMessage = "T&C Date should be greater than or equal to CRM Request Date";
            }
            else if (testingAndCommissioning.TandCCompletedDate != null && testingAndCommissioning.TandCCompletedDate != DateTime.MinValue 
                && ((DateTime)testingAndCommissioning.TandCCompletedDate).Date > currentDate)
            {
                ErrorMessage = "T&C Completed Date cannot be a future date";
            }
            else if (testingAndCommissioning.TandCCompletedDate != null && testingAndCommissioning.TandCCompletedDate != DateTime.MinValue
                && testingAndCommissioning.TandCDate != DateTime.MinValue
                && ((DateTime)testingAndCommissioning.TandCCompletedDate).Date < testingAndCommissioning.TandCDate)
            {
                ErrorMessage = "T&C Completed Date should be greater than or equal to T&C Date";
            }
            else if (testingAndCommissioning.HandoverDate != null && testingAndCommissioning.HandoverDate != DateTime.MinValue
                && testingAndCommissioning.TandCDate != DateTime.MinValue
                && ((DateTime)testingAndCommissioning.HandoverDate).Date < testingAndCommissioning.TandCDate)
            {
                ErrorMessage = "Handover Date should be greater than or equal to T&C Date";
            }
            else if (testingAndCommissioning.HandoverDate != null && testingAndCommissioning.HandoverDate != DateTime.MinValue
               && testingAndCommissioning.TandCCompletedDate != null && testingAndCommissioning.TandCCompletedDate != DateTime.MinValue
               && ((DateTime)testingAndCommissioning.HandoverDate).Date < testingAndCommissioning.TandCCompletedDate)
            {
                ErrorMessage = "Handover Date should be greater than or equal to T&C Completed Date";
            }
            else if (testingAndCommissioning.HandoverDate != null && testingAndCommissioning.HandoverDate != DateTime.MinValue
                && ((DateTime)testingAndCommissioning.HandoverDate).Date > currentDate)
            {
                ErrorMessage = "Handover Date cannot be a future date";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _TestingAndCommissioningDAL.GetAll(pageFilter);
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
        public TestingAndCommissioning Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _TestingAndCommissioningDAL.Get(Id);
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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _TestingAndCommissioningDAL.Delete(Id, out ErrorMessage);
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
    }
}
