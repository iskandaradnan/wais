using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Models.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class CustomerBAL : ICustomerBAL
    {
        private readonly ICustomerDAL _customerDAL;

        private readonly static string fileName = nameof(CustomerBAL);

        #region Ctor/init
        public CustomerBAL(ICustomerDAL customerDAL)
        {
            _customerDAL = customerDAL;

        }
        #endregion

        #region Business Access Methods
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _customerDAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
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

        public CustomerMstViewModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _customerDAL.Load();
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
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
        public CustomerMstViewModel Get(int CustomerId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _customerDAL.Get(CustomerId);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
        public void Delete(int CustomerId, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                _customerDAL.Delete(CustomerId, out ErrorMessage);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());


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
        public CustomerMstViewModel Save(CustomerMstViewModel customer, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                CustomerMstViewModel result = null;

                if (IsValid(customer, out ErrorMessage))
                {
                    result = _customerDAL.Save(customer, out ErrorMessage);
                }

                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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
        private bool IsValid(CustomerMstViewModel customer, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(customer.CustomerName) || string.IsNullOrEmpty(customer.Address)
                || customer.Latitude == 0 || customer.Longitude == 0 || customer.ActiveFromDate == null)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (_customerDAL.IsRecordModified(customer))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public ActiveFacility GetFacilityList(int customerId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _customerDAL.GetFacilityList(customerId);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
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
        public ReportsAndRecordsList SaveReportsAndRecords(ReportsAndRecordsList ReportsAndRecords, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                ReportsAndRecordsList result = null;

                result = _customerDAL.SaveReportsAndRecords(ReportsAndRecords, out ErrorMessage);

                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
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
        public ReportsAndRecordsList GetReportsAndRecords(int CustomerId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetReportsAndRecords), Level.Info.ToString());
                var result = _customerDAL.GetReportsAndRecords(CustomerId);
                Log4NetLogger.LogExit(fileName, nameof(GetReportsAndRecords), Level.Info.ToString());
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
        #endregion
    }
}