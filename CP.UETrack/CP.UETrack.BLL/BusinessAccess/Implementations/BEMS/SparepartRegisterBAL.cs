using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class SparepartRegisterBAL : ISparepartRegisterBAL
    {
        #region Ctor/init
        private readonly ISparepartRegisterDAL _dal;
        private readonly static string fileName = nameof(AssetClassificationBAL);
        public SparepartRegisterBAL(ISparepartRegisterDAL dal)
        {
            _dal = dal;

        }
        #endregion

        public EngSparePartsLovs Load()
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

        public EngSpareParts Get(int Id)
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

        public EngSpareParts Save(EngSpareParts obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                EngSpareParts result = null;

                if (IsValid(obj, out ErrorMessage))
                {
                    result = _dal.Save(obj, out ErrorMessage);
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

        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                _dal.Delete(Id, out ErrorMessage);
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
        private bool IsValid(EngSpareParts model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(model.ItemCode))

            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }           
            else
            {
                isValid = true;
            }
            return isValid;
        }
        //public static bool validateExpiryDate(EngSpareParts model)
        //{
        //    var CurrentDate = DateTime.Now;
        //    var date = CurrentDate.Date;
        //    return (model.IsExpirydate && model.ExpiryDate < date) ? false : true;
        //}

        public ImageVideoUploadModel SPImageVideoSave(ImageVideoUploadModel ImageVideo)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(SPImageVideoSave), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                ImageVideoUploadModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _dal.SPImageVideoSave(ImageVideo);
                //}

                Log4NetLogger.LogExit(fileName, nameof(SPImageVideoSave), Level.Info.ToString());
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

        public ImageVideoUploadModel SPGetUploadDetails(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(SPGetUploadDetails), Level.Info.ToString());
                var result = _dal.SPGetUploadDetails(Id);
                Log4NetLogger.LogExit(fileName, nameof(SPGetUploadDetails), Level.Info.ToString());
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

        public bool SPFileDelete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(SPFileDelete), Level.Info.ToString());
                var result = _dal.SPFileDelete(Id);
                Log4NetLogger.LogExit(fileName, nameof(SPFileDelete), Level.Info.ToString());
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
    }
}
