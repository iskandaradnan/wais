using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class AssetInformationBAL : IAssetInformationBAL
    {
        private string _FileName = nameof(AssetInformationBAL);
        IAssetInformationDAL _AssetInformationDAL;
        public AssetInformationBAL(IAssetInformationDAL AssetInformationDAL)
        {
            _AssetInformationDAL = AssetInformationDAL;
        }
        public BlockFacilityDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _AssetInformationDAL.Load();
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
        public AssetInformationViewModel Save(AssetInformationViewModel AssetInformation, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AssetInformationViewModel result = null;

                //if (IsValid(AssetInformation, out ErrorMessage))
                //{
                    result = _AssetInformationDAL.Save(AssetInformation,out ErrorMessage);
                //}

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
        private bool IsValid(AssetInformationViewModel AssetInformation, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (string.IsNullOrEmpty(AssetInformation.AssetInfoValue) || AssetInformation.AssetInfoId == 0 || AssetInformation.AssetInfoType == 0)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (_AssetInformationDAL.IsRoleDuplicate(AssetInformation))
            {
                ErrorMessage = "User Role should be unique";
            }
            else if (_AssetInformationDAL.IsRecordModified(AssetInformation))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
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
                var result = _AssetInformationDAL.GetAll(pageFilter);
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

        public AssetInformationViewModel Get(int Id, int AssetInfoType)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetInformationDAL.Get(Id, AssetInfoType);
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

        public void Delete(int Id, int AssetInfoType)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _AssetInformationDAL.Delete(Id, AssetInfoType);
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
