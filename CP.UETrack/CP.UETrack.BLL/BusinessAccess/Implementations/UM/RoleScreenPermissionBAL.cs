using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;
using CP.UETrack.Models;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class RoleScreenPermissionBAL : IRoleScreenPermissionBAL
    {
        private string _FileName = nameof(RoleScreenPermissionBAL);
        IRoleScreenPermissionDAL _RoleScreenPermissionDAL;
        public RoleScreenPermissionBAL(IRoleScreenPermissionDAL roleScreenPermissionDAL)
        {
            _RoleScreenPermissionDAL = roleScreenPermissionDAL;
        }
        public List<UserRoleType> GetUserRoles()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                var result = _RoleScreenPermissionDAL.GetUserRoles();
                Log4NetLogger.LogExit(_FileName, nameof(GetUserRoles), Level.Info.ToString());
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
        public List<UMRoleScreenPermission> Fetch(int RoleId, int ModuleId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Fetch), Level.Info.ToString());
                var result = _RoleScreenPermissionDAL.Fetch(RoleId, ModuleId);
                Log4NetLogger.LogExit(_FileName, nameof(Fetch), Level.Info.ToString());
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
        public bool Save(RoleScreenPermissions roleScreenPermissions, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var result = false;

                if (IsValid(roleScreenPermissions, out ErrorMessage))
                {
                    result = _RoleScreenPermissionDAL.Save(roleScreenPermissions);
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
        private bool IsValid(RoleScreenPermissions roleScreenPermissions, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (roleScreenPermissions.roleScreenPermissions.Count == 0)
            {
                ErrorMessage = "There are no records to save";
            }
            else if (!_RoleScreenPermissionDAL.IsUserRoleActive(roleScreenPermissions.roleScreenPermissions[0].UMUserRoleId))
            {
                ErrorMessage = "The selected role has been inactivated.";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public List<LovValue> GetModules(int UserTypeId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Fetch), Level.Info.ToString());
                var result = _RoleScreenPermissionDAL.GetModules(UserTypeId);
                Log4NetLogger.LogExit(_FileName, nameof(Fetch), Level.Info.ToString());
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
