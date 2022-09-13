using CP.UETrack.BLL.BusinessAccess.Contracts.Portering;
using System;
using CP.UETrack.Model.Portering;
using CP.UETrack.DAL.DataAccess.Contracts.Portering;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.Portering
{
    public class LoanerBookingBAL : ILoanerBookingBAL
    {
        #region Ctor/init
        private readonly ILoanerBookingDAL _dal;
        private readonly static string fileName = nameof(LoanerBookingBAL);
        public LoanerBookingBAL(ILoanerBookingDAL dal)
        {
            _dal = dal;

        }
        #endregion
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                _dal.Delete(Id, out ErrorMessage);
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());

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

        public LoanerBooking Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _dal.Get(Id);
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
        public LoanerBooking GetBookingDates(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetBookingDates), Level.Info.ToString());
                var result = _dal.GetBookingDates(Id);
                Log4NetLogger.LogExit(fileName, nameof(GetBookingDates), Level.Info.ToString());
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

        public PorteringLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.Load();
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

        public LoanerBooking Save(LoanerBooking model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                LoanerBooking result = null;

                if (IsValid(model, out ErrorMessage))
                {
                    result = _dal.Save(model, out ErrorMessage);
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
        private static bool IsValid(LoanerBooking model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.AssetId == 0)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }

            else if (model.BookingStartFrom == null || model.BookingEnd == null)
            {
                if (model.BookingStartFrom == null && model.BookingEnd == null)
                    ErrorMessage = "4";
                else if (model.BookingEnd == null)
                    ErrorMessage = "5";
                else if (model.BookingStartFrom == null)
                    ErrorMessage = "6";

            }
            else if (model.BookingStartFrom.Date > model.BookingEnd.Date)
                ErrorMessage = "7";
            else if (!validateBookingStartDate(model))
            {
                ErrorMessage = "1";
            }
            else if (!validateBookingEndDate(model))
            {
                ErrorMessage = "2";
            }
            else if (!validateBookingDates(model))
            {
                ErrorMessage = "3";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        private static bool validateBookingDates(LoanerBooking model)
        {
            var CurrentDate = DateTime.Now;
            var date = CurrentDate.Date;
            return (model.BookingStartFrom > model.BookingEnd) ? false : true;
        }

        private static bool validateBookingEndDate(LoanerBooking model)
        {
            var CurrentDate = DateTime.Now;
            var date = CurrentDate.Date;
            return (model.LoanerTestEquipmentBookingId == 0 && model.BookingEnd < date) ? false : true;
        }

        private static bool validateBookingStartDate(LoanerBooking model)
        {
            var CurrentDate = DateTime.Now;
            var date = CurrentDate.Date;
            return (model.LoanerTestEquipmentBookingId == 0 && model.BookingStartFrom < date) ? false : true;
        }
    }
}
