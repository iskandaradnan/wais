
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class AssetStandardizationBAL : IAssetStandardizationBAL
    {
        private string _FileName = nameof(AssetStandardizationBAL);
        IAssetStandardizationDAL _AssetStandardizationDAL;

        public AssetStandardizationBAL(IAssetStandardizationDAL assetStandardizationDAL)
        {
            _AssetStandardizationDAL = assetStandardizationDAL;
        }
        public AssetStandardizationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _AssetStandardizationDAL.Load();
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
        public AssetStandardization Save(AssetStandardization assetStandardization, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AssetStandardization result = null;

                if (IsValid(assetStandardization, out ErrorMessage))
                {
                    result = _AssetStandardizationDAL.Save(assetStandardization, out ErrorMessage);
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
        private bool IsValid(AssetStandardization assetStandardization, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            //if (assetStandardization.ManufacturerId == 0)
            //{
            //    ErrorMessage = "Please enter a valid Manufacturer.";
            //}
            //else if (assetStandardization.ModelId == 0)
            //{
            //    ErrorMessage = "Please enter a valid Model.";
            //}
            //else 
            //if (_AssetStandardizationDAL.IsManufacturerDuplicate(assetStandardization))
            //{
            //    ErrorMessage = "Manufacturer should be unique";
            //}
            //else 
            if (_AssetStandardizationDAL.IsModelDuplicate(assetStandardization))
            {
                ErrorMessage = "Model should be unique";
            }
            //else if (_AssetStandardizationDAL.IsManufacturerModelDuplicate(assetStandardization))
            //{
            //    ErrorMessage = "Combination of Manufacturer and Model should be unique for a Type Code";
            //}
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
                var result = _AssetStandardizationDAL.GetAll(pageFilter);
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
        public AssetStandardization Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetStandardizationDAL.Get(Id);
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
                _AssetStandardizationDAL.Delete(Id, out ErrorMessage);
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
