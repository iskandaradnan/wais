using FluentValidation;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class NavigationBAL : INavigationBAL
    {
        private readonly INavigationDAL _naviDalValue;
        private string _FileName = nameof(AssetRegisterBAL);
        Log4NetLogger log = new Log4NetLogger();

        public NavigationBAL(INavigationDAL naviDal)
        {
            _naviDalValue = naviDal;
        }
        public List<Menus> GetAllMenuItems()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ActionPermissionCachedData), Level.Info.ToString());
                var restult = _naviDalValue.GetAllMenuItems();
                Log4NetLogger.LogEntry(_FileName, nameof(ActionPermissionCachedData), Level.Info.ToString());
                return restult;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public List<UserActionPermissions> ActionPermissionCachedData()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ActionPermissionCachedData), Level.Info.ToString());
                var restult =  _naviDalValue.ActionPermissionCachedData();
                Log4NetLogger.LogEntry(_FileName, nameof(ActionPermissionCachedData), Level.Info.ToString());
                return restult;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public UserDetailsModel GetThemeColor()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetThemeColor), Level.Info.ToString());
                var result = _naviDalValue.GetThemeColor();
                Log4NetLogger.LogExit(_FileName, nameof(GetThemeColor), Level.Info.ToString());
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
