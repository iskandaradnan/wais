using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class AssetClassificationBAL : IAssetClassificationBAL
    {
        #region Ctor/init
        private readonly IAssetClassificationDAL _assetClassificationDAL;
        private readonly static string fileName = nameof(AssetClassificationBAL);
        public AssetClassificationBAL(IAssetClassificationDAL assetClassificationDAL)
        {
            _assetClassificationDAL = assetClassificationDAL;

        }
        #endregion
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _assetClassificationDAL.GetAll(pageFilter);
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter, int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _assetClassificationDAL.GetAll(pageFilter,Id);
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
        public GridFilterResult GetAllFEMS(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAllFEMS), Level.Info.ToString());
                var result = _assetClassificationDAL.GetAllFEMS(pageFilter);
                Log4NetLogger.LogExit(fileName, nameof(GetAllFEMS), Level.Info.ToString());
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
        public AssetClassificationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _assetClassificationDAL.Load();
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

        public EngAssetClassification Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _assetClassificationDAL.Get(Id);
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

        public EngAssetClassification SaveUpdate(EngAssetClassification obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(SaveUpdate), Level.Info.ToString());
                ErrorMessage = string.Empty;
                EngAssetClassification result = null;

                if (IsValid(obj, out ErrorMessage))
                {
                    result = _assetClassificationDAL.SaveUpdate(obj);
                }
                Log4NetLogger.LogExit(fileName, nameof(SaveUpdate), Level.Info.ToString());
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
                _assetClassificationDAL.Delete(Id, out ErrorMessage);
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
        private bool IsValid(EngAssetClassification model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(model.AssetClassification))

            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            //else if (_assetClassificationDAL.IsClassificationCodeDuplicate(model))
            //{
            //    ErrorMessage = "Asset Classication Code should be unique";
            //}
            else if (_assetClassificationDAL.IsRecordModified(model))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
    }
}
