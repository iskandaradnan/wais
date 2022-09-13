using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using System;
using System.Collections.Generic;
using CP.UETrack.Model.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class TypeCodeDetailsBAL : ITypeCodeDetailsBAL
    {
        #region Ctor/init
        private readonly ITypeCodeDetailsDAL _dal;
        private readonly static string fileName = nameof(TypeCodeDetailsBAL);
        public TypeCodeDetailsBAL(ITypeCodeDetailsDAL dal)
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

        public EngAssetTypeCode Get(int Id)
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

        public EngAssetTypeCodeLovs Load()
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

        public EngAssetTypeCode Save(EngAssetTypeCode model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                EngAssetTypeCode result = null;
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
        public List<EngAssetTypeCodeAddSpecification> GetAssetTypeCodeAddSpecifications(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _dal.GetAssetTypeCodeAddSpecifications(Id);
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

        private static bool IsValid(EngAssetTypeCode model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(model.AssetTypeCode) || string.IsNullOrEmpty(model.AssetTypeDescription))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (!ValidateQAPServiceAvailability(model))
            {
                ErrorMessage = "1";
            }
            else if (!ValidateQAPServiceDates(model))
            {
                ErrorMessage = "2";
            }
            else if (!ValidateVarationDate(model))
            {
                ErrorMessage = "Enter valid Varation  Effective From Date";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public static bool ValidateQAPServiceAvailability(EngAssetTypeCode model)
        {
            var isValid = true; 
            if (model.QAPServiceAvailabilityB2 )
            {
                if (model.EffectiveFrom == null || model.EffectiveTo == null || !model.QAPUptimeTargetPerc.HasValue)
                    isValid = false; 
                else if (model.QAPUptimeTargetPerc > 100 || model.QAPUptimeTargetPerc <= 0)
                    isValid = false;
            }
            else
                isValid = true;
            return isValid;

        }
        public static bool ValidateQAPServiceDates(EngAssetTypeCode model)
        {
            var isValid = true;
            if (model.QAPServiceAvailabilityB2)
            {
                if (model.EffectiveFrom > model.EffectiveTo)
                {
                    isValid = false; 
                }
            }
            return isValid;
        }
        private static bool ValidateVarationDate(EngAssetTypeCode model)
        {
            var count = 0;
            if (model.EngAssetTypeCodeVariationRates != null && model.EngAssetTypeCodeVariationRates.Count > 0)
            {
                foreach (var vrate in model.EngAssetTypeCodeVariationRates)
                {
                    if (vrate.EffectiveFromDate == null)
                    {
                        count++;
                    }
                }
            }
            return (count > 0) ? false : true;
        }
    }
}
