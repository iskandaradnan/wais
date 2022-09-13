using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class UserRegistrationBAL : IUserRegistrationBAL
    {
        private string _FileName = nameof(UserRegistrationBAL);
        IUserRegistrationDAL _UserRegistrationDAL;
        public UserRegistrationBAL(IUserRegistrationDAL userRegistrationDAL)
        {
            _UserRegistrationDAL = userRegistrationDAL;
        }
        public UserRegistrationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _UserRegistrationDAL.Load();
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
        public UMUserRegistration Save(UMUserRegistration userRegistration, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                UMUserRegistration result = null;

                if (IsValid(userRegistration, out ErrorMessage))
                {
                    result = _UserRegistrationDAL.Save(userRegistration);
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
        private bool IsValid(UMUserRegistration userRegistration, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            var checkNoOfUsersForContractor = false;

            checkNoOfUsersForContractor = (userRegistration.UserRegistrationId == 0) && (userRegistration.UserTypeId == 4) && (userRegistration.ContractorId != 0);

            var currentDate = DateTime.Now.Date;
            if (userRegistration.DateJoined != DateTime.MinValue && userRegistration.DateJoined.Date > currentDate)
            {
                ErrorMessage = "Date Of Joining cannot be a future date";
            }
            else if (_UserRegistrationDAL.IsUserNameDuplicate(userRegistration))
            {
                ErrorMessage = "Username should be unique";
            }
            else if (_UserRegistrationDAL.IsEmailDuplicate(userRegistration))
            {
                ErrorMessage = "Email should be unique";
            }
            else if (_UserRegistrationDAL.IsEmployeeIdDuplicate(userRegistration))
            {
                ErrorMessage = "EmployeeId should be unique";
            }
            else if (_UserRegistrationDAL.IsRecordModified(userRegistration))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            } else if (checkNoOfUsersForContractor && _UserRegistrationDAL.IsNoOfUsersExceeds(userRegistration.ContractorId)) {
                ErrorMessage = "Cannot create user for the selected contractor, as the number of users exceeds the maximum number allowed.";
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
                var result = _UserRegistrationDAL.GetAll(pageFilter);
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
        public UMUserRegistration Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _UserRegistrationDAL.Get(Id);
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
                _UserRegistrationDAL.Delete(Id, out ErrorMessage);
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
        public UserRegistrationLovs GetUserRoles(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetUserRoles), Level.Info.ToString());
                var result = _UserRegistrationDAL.GetUserRoles(Id);
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
        public UserRegistrationLovs GetLocations(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetLocations), Level.Info.ToString());
                var result = _UserRegistrationDAL.GetLocations(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetLocations), Level.Info.ToString());
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
        public UserRegistrationLovs GetAllLocations()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAllLocations), Level.Info.ToString());
                var result = _UserRegistrationDAL.GetAllLocations();
                Log4NetLogger.LogExit(_FileName, nameof(GetAllLocations), Level.Info.ToString());
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
        public List<object> GetStaffNames()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetStaffNames), Level.Info.ToString());
                var result = _UserRegistrationDAL.GetStaffNames();
                Log4NetLogger.LogExit(_FileName, nameof(GetStaffNames), Level.Info.ToString());
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
