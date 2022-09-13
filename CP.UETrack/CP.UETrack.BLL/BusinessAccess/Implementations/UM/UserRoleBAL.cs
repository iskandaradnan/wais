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
    public class UserRoleBAL : IUserRoleBAL
    {
        private string _FileName = nameof(UserRoleBAL);
        IUserRoleDAL _UserRoleDAL;
        public UserRoleBAL(IUserRoleDAL userRoleDAL)
        {
            _UserRoleDAL = userRoleDAL;
        }
        public UserRoleLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _UserRoleDAL.Load();
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
        public UMUserRole Save(UMUserRole userRole, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                UMUserRole result = null;

                if (IsValid(userRole, out ErrorMessage))
                {
                    result = _UserRoleDAL.Save(userRole);
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
        private bool IsValid(UMUserRole userRole, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (string.IsNullOrEmpty(userRole.Name) || userRole.UserTypeId == 0 || userRole.Status == 0)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (_UserRoleDAL.IsRoleDuplicate(userRole))
            {
                ErrorMessage = "Name should be unique";
            }
            else if (userRole.Status == 2 && _UserRoleDAL.IsRoleReferenced(userRole))
            {
                ErrorMessage = "Cannot Inactivate the user role as it is already mapped to users";
            }
            else if (_UserRoleDAL.IsRecordModified(userRole))
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
                var result = _UserRoleDAL.GetAll(pageFilter);
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

        public UMUserRole Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _UserRoleDAL.Get(Id);
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
                _UserRoleDAL.Delete(Id, out ErrorMessage);
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
        public GridFilterResult Export(SortPaginateFilter pageFilter, string ExportType)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                var result = _UserRoleDAL.Export(pageFilter, ExportType);
                Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
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
