using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;


namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class UserLocationBAL : IUserLocationBAL
    {
        private readonly IUserLocationDAL _userLocationDAL;
        private readonly IUserAreaDAL _userareaDal;
        private readonly static string fileName = nameof(UserAreaBAL);
        public UserLocationBAL(IUserLocationDAL dal, IUserAreaDAL areadal)
        {
            _userLocationDAL = dal;
            _userareaDal = areadal;
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _userLocationDAL.GetAll(pageFilter);
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


        public MstLocationUserLocationLovs Load(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _userLocationDAL.Load(Id);
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
        public MstLocationUserLocation Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _userLocationDAL.Get(Id);
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

        public MstLocationUserLocation Save(MstLocationUserLocation obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                MstLocationUserLocation result = null;

                if (IsValid(obj, out ErrorMessage))
                {
                    result = _userLocationDAL.Save(obj);
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

        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                _userLocationDAL.Delete(Id, out ErrorMessage);
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
        private bool IsValid(MstLocationUserLocation model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(model.UserLocationCode) || string.IsNullOrEmpty(model.UserLocationName) || string.IsNullOrEmpty(model.UserAreaName))

            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (!model.Active && model.ActiveToDate == null)
            {
                ErrorMessage = "Stop Service Date is Mandatory when Status is Inactive.";
            }
            //else if (!validateActiveToDate(model))
            //{
            //    ErrorMessage = "1"; // active date cannot be future date 
            //}
            else if (ValidateUserLocationStartDate(model))
            {
                ErrorMessage = "2"; // comparing start date should be greater than area date 
            }
            else if (_userLocationDAL.IsUserLocationCodeDuplicate(model))
            {
                ErrorMessage = "User Location Code should be unique";
            }
            else if (_userLocationDAL.IsRecordModified(model))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public static bool validateActiveToDate(MstLocationUserLocation model)
        {
            var CurrentDate = DateTime.Now;
            var date = CurrentDate.Date;
            return (!model.Active && model.ActiveToDate > date) ? false : true;
        }


        public bool ValidateUserLocationStartDate(MstLocationUserLocation model)
        {
            var obj = _userareaDal.Get(model.UserAreaId);
            var userareaStartDate = obj.ActiveFromDate;
            return (model.ActiveFromDate >= userareaStartDate) ? false : true;
        }

        //public static bool validateActiveToDate(MstLocationUserLocation model)
        //{
        //    var CurrentDate = DateTime.Now;
        //    var date = CurrentDate.Date;
        //    return (!model.Active && model.ActiveToDate > date) ? false : true;
        //}
    }
}
