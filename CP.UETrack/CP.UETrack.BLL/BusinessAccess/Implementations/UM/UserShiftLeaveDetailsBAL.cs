
using CP.UETrack.BLL.BusinessAccess.Implementations.UM;
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.DAL.DataAccess.Implementations.UM;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.Model;
using CP.UETrack.Model.GM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.UM;
using CP.UETrack.BLL.BusinessAccess.Contracts.UM;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.UM
{
    public class UserShiftLeaveDetailsBAL : IUserShiftLeaveDetailsBAL
    {
        private string _FileName = nameof(UserShiftLeaveDetailsBAL);
        IUserShiftLeaveDetailsDAL _UserShiftLeaveDetailsDAL;
        public UserShiftLeaveDetailsBAL(IUserShiftLeaveDetailsDAL UserShiftLeaveDetailsDAL)
        {
            _UserShiftLeaveDetailsDAL = UserShiftLeaveDetailsDAL;
        }
        public UserShiftLeaveDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _UserShiftLeaveDetailsDAL.Load();
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _UserShiftLeaveDetailsDAL.GetAll(pageFilter);
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
        public UserShiftLeaveViewModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _UserShiftLeaveDetailsDAL.Get(Id);
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
        public UserShiftLeaveViewModel GetLeaveDetails(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetLeaveDetails), Level.Info.ToString());
                var result = _UserShiftLeaveDetailsDAL.GetLeaveDetails(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetLeaveDetails), Level.Info.ToString());
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
        public UserShiftLeaveViewModel Save(UserShiftLeaveViewModel UserShiftLeave, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                UserShiftLeaveViewModel result = null;

                //if (IsValid(userRegistration, out ErrorMessage))
                //{
                    result = _UserShiftLeaveDetailsDAL.Save(UserShiftLeave, out ErrorMessage);
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
    }
}
