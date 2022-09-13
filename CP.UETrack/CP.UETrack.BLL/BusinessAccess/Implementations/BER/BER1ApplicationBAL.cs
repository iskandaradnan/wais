using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BER;
using CP.UETrack.DAL.DataAccess.Contracts.BER;
using CP.UETrack.Model;
using CP.UETrack.Model.BER;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BER
{
    public class BER1ApplicationBAL : IBER1ApplicationBAL
    {
        #region Ctor/init
        private readonly IBER1ApplicationDAL _dal;
        private readonly static string fileName = nameof(BER1ApplicationBAL);
        public BER1ApplicationBAL(IBER1ApplicationDAL dal)
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

        public BERApplicationTxn Get(int Id)
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




        public BERApplicationTxn Get(string Id)
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





        public BERApplicationTxn ArpGet(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.ArpGet(Id);
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

        public BERApplicationTxnLovs Load()
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

        public BERApplicationTxn Save(BERApplicationTxn model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                BERApplicationTxn result = null;

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


        private static bool IsValidAttachments(BERApplicationTxn model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.ApplicantStaffId == 0)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        private static bool IsValid(BERApplicationTxn model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            var currentDate = DateTime.Now.Date;

            if (string.IsNullOrEmpty(model.AssetNo) || model.AssetId == 0)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            } else if (model.ApplicationDate.Date > currentDate)
            {
                ErrorMessage = "Application Date cannot be Future Date";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        private static bool ValidateApplicationDate(BERApplicationTxn model)
        {
            var IsValid = true;
            var date = DateTime.Now;
            var currentDate = date.Date;

            if (model.ApplicationId == 0)
            {
                if (model.ApplicationDate > currentDate)
                {
                    IsValid = false;
                }
                else
                {
                    IsValid = true;
                }
            }

            return IsValid;

        }

        public BERApplicationTxn GetAttachmentDetails(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.GetAttachmentDetails(id);
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



        public BERApplicationTxn GetApplicationHistiry(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.GetApplicationHistiry(id);
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
        public BERApplicationTxn GetMaintainanceHistory(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetMaintainanceHistory), Level.Info.ToString());
                var result = _dal.GetMaintainanceHistory(id);
                Log4NetLogger.LogExit(fileName, nameof(GetMaintainanceHistory), Level.Info.ToString());
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
        public BERApplicationTxn GetBerCurrentValueHistory(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.GetBerCurrentValueHistory(id);
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
        public BERApplicationTxn SaveDocument(BERApplicationTxn document, out string errorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.SaveDocument(document, out errorMessage);
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

        public BerAdditionalFields GetAdditionalInfoForBer(int ApplicationId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.GetAdditionalInfoForBer(ApplicationId);
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

        public BerAdditionalFields SaveAdditionalInfoForBer(BerAdditionalFields AdditionalInfo, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(SaveAdditionalInfoForBer), Level.Info.ToString());

                ErrorMessage = string.Empty;
                BerAdditionalFields result = null;

                result = _dal.SaveAdditionalInfoForBer(AdditionalInfo, out ErrorMessage);

                Log4NetLogger.LogExit(fileName, nameof(SaveAdditionalInfoForBer), Level.Info.ToString());
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
