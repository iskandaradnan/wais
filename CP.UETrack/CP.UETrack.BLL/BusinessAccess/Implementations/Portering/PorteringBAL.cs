using CP.UETrack.BLL.BusinessAccess.Contracts.Portering;
using System;
using CP.UETrack.Model.Portering;
using CP.UETrack.DAL.DataAccess.Contracts.Portering;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Implementations.Portering;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.Portering
{
    public class PorteringBAL : IPorteringBAL
    {
        #region Ctor/init
        private readonly IPorteringDAL _dal;
        private readonly static string fileName = nameof(PorteringBAL);
        public PorteringBAL(IPorteringDAL dal)
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

        public PorteringModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.Get(Id);
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
        public PorteringModel GetLoanerBookingRecord(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.GetLoanerBookingRecord(Id);
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

        public PorteringModel GetPorteringHistory(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.GetPorteringHistory(Id);
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

        //public PorteringModel GetReceipt(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
        //        var result = _dal.GetReceipt(Id);
        //        Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
        //        return result;

        //    }
        //    catch (BALException bx)
        //    {
        //        throw new BALException(bx);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new BALException(ex);
        //    }
        //}

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
        public PorteringLovs GetLocationList(PorteringLovs lov)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.GetLocationList(lov);
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
        public PorteringModel Save(PorteringModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                PorteringModel result = null;

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

     
        private  bool IsValid(PorteringModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.AssetId == 0 || model.AssetId == null || model.MovementCategory == 0)

            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (!ValidatePorteringDate(model))
            {
                ErrorMessage = "Asset Tracker Date cannot be Future Date";
            }

            else if (!ValidateConsignmentDate(model))
            {
                ErrorMessage = "Consignment Date should be greater than Asset Tracker Date";
            }

            //else if (_dal.ValidateBookingEndDate(model))
            //{
            //    ErrorMessage = "Booking end date ";
            //}
            else
            {
                isValid = true;
            }
            return isValid;
        }

        private static bool ValidateConsignmentDate(PorteringModel model)
        {
            var isValid = true; 
            if (model.ModeOfTransport != null && model.ModeOfTransport == 218)
            {
                if (model.ConsignmentDate < model.PorteringDate)
                {
                    isValid = false; 
                }
            }
            return isValid; 
        }

        //private  static bool ValidateBookingEndDate(PorteringModel model)
        //{

        //    try
        //    {





        //        var result = true;
        //        Log4NetLogger.LogEntry(fileName, nameof(ValidateBookingEndDate), Level.Info.ToString());
        //        result = _dal.ValidateBookingEndDate(model);

        //        Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }

        //    catch (Exception ex)
        //    {
        //        throw new BALException(ex);
        //    }



        //}

        private static bool ValidatePorteringDate(PorteringModel model)
        {
            var CurrentDate = DateTime.Now;
            var date = CurrentDate.Date;
            return (model.PorteringId == 0 && model.PorteringDate > date) ? false : true;
        }

        public PorteringLovs GetVendorInfo(int SupplierCategoryid, int AsseetId)
        {

            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                var result = _dal.GetVendorInfo(SupplierCategoryid, AsseetId);
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
    }
}
