
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class AdditionalFieldsBAL : IAdditionalFieldsBAL
    {
        private string _FileName = nameof(AdditionalFieldsBAL);
        IAdditionalFieldsDAL _AdditionalFieldsDAL;

        public AdditionalFieldsBAL(IAdditionalFieldsDAL additionalFieldsDAL)
        {
            _AdditionalFieldsDAL = additionalFieldsDAL;
        }
        public AdditionalFieldsLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _AdditionalFieldsDAL.Load();
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
        public AdditionalFieldsConfig Save(AdditionalFieldsConfig AdditionalFieldsConfig, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AdditionalFieldsConfig result = null;

                if (IsValid(AdditionalFieldsConfig, out ErrorMessage))
                {
                    result = _AdditionalFieldsDAL.Save(AdditionalFieldsConfig, out ErrorMessage);
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
        private bool IsValid(AdditionalFieldsConfig additionalFields, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = true;
            return isValid;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _AdditionalFieldsDAL.GetAll(pageFilter);
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
        public AdditionalFieldsConfig Get(int CustomerId, int ScreenId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AdditionalFieldsDAL.Get(CustomerId, ScreenId);
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _AdditionalFieldsDAL.Delete(Id);
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
        public AssetRegisterAdditionalFields GetAdditionalInfoForAsset(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForAsset), Level.Info.ToString());
                var result = _AdditionalFieldsDAL.GetAdditionalInfoForAsset(AssetId);
                Log4NetLogger.LogExit(_FileName, nameof(GetAdditionalInfoForAsset), Level.Info.ToString());
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
        public AssetRegisterAdditionalFields SaveAdditionalInfoForAsset(AssetRegisterAdditionalFields AdditionalInfo, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoForAsset), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AssetRegisterAdditionalFields result = null;

                result = _AdditionalFieldsDAL.SaveAdditionalInfoForAsset(AdditionalInfo, out ErrorMessage);
                
                Log4NetLogger.LogExit(_FileName, nameof(SaveAdditionalInfoForAsset), Level.Info.ToString());
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
        public TestingAndCommissioningAdditionalFields GetAdditionalInfoForTAndC(int TestingandCommissioningId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForTAndC), Level.Info.ToString());
                var result = _AdditionalFieldsDAL.GetAdditionalInfoForTAndC(TestingandCommissioningId);
                Log4NetLogger.LogExit(_FileName, nameof(GetAdditionalInfoForTAndC), Level.Info.ToString());
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
        public TestingAndCommissioningAdditionalFields SaveAdditionalInfoTAndC(TestingAndCommissioningAdditionalFields AdditionalInfo, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoTAndC), Level.Info.ToString());

                ErrorMessage = string.Empty;
                TestingAndCommissioningAdditionalFields result = null;

                result = _AdditionalFieldsDAL.SaveAdditionalInfoTAndC(AdditionalInfo, out ErrorMessage);

                Log4NetLogger.LogExit(_FileName, nameof(SaveAdditionalInfoTAndC), Level.Info.ToString());
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
        public workorderAdditionalFields GetAdditionalInfoForWorkorder(int WorkOrderId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForWorkorder), Level.Info.ToString());
                var result = _AdditionalFieldsDAL.GetAdditionalInfoForWorkorder(WorkOrderId);
                Log4NetLogger.LogExit(_FileName, nameof(GetAdditionalInfoForWorkorder), Level.Info.ToString());
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
        public workorderAdditionalFields SaveAdditionalInfoWorkorder(workorderAdditionalFields AdditionalInfo, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveAdditionalInfoWorkorder), Level.Info.ToString());

                ErrorMessage = string.Empty;
                workorderAdditionalFields result = null;

                result = _AdditionalFieldsDAL.SaveAdditionalInfoWorkorder(AdditionalInfo, out ErrorMessage);

                Log4NetLogger.LogExit(_FileName, nameof(SaveAdditionalInfoWorkorder), Level.Info.ToString());
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
