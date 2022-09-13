using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class UserAreaBAL : IUserAreaBAL
    {
        #region Ctor/init
        private readonly IUserAreaDAL _userAreaDAL;
        private readonly static string fileName = nameof(UserAreaBAL);
        public UserAreaBAL(IUserAreaDAL userareaDAL)
        {
            _userAreaDAL = userareaDAL;

        }
        #endregion
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _userAreaDAL.GetAll(pageFilter);
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
        public AreaLovs Load(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _userAreaDAL.Load(id);
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

        public MstLocationUserAreaViewModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _userAreaDAL.Get(Id);
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

        public MstLocationUserAreaViewModel Save(MstLocationUserAreaViewModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                MstLocationUserAreaViewModel result = null;

                if (IsValid(obj, out ErrorMessage))
                {
                    result = _userAreaDAL.Save(obj);
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

        public void Delete(int Id,out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                _userAreaDAL.Delete(Id,  out  ErrorMessage);
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
        private bool IsValid(MstLocationUserAreaViewModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(model.UserAreaCode) || string.IsNullOrEmpty(model.UserAreaName))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }



            //else if (!validateActiveToDate(model))
            //{
            //    ErrorMessage = "1"; // active date cannot be future date 
            //}
            else if (_userAreaDAL.IsUserAreaDuplicate(model))
            {
                ErrorMessage = "User Area Code should be unique";
            }
            else if (_userAreaDAL.IsRecordModified(model))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            }
            else if ( model.UserAreaId != 0 && !model.Active && _userAreaDAL.AreAllLocationsInactive(model.UserAreaId))
            {
                ErrorMessage = "User Area Cannot be inactive. One or more User location is Active for this User Area ";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public static bool validateActiveToDate(MstLocationUserAreaViewModel model)
        {
            var CurrentDate = DateTime.Now;
            var date = CurrentDate.Date;
            return (!model.Active && model.ActiveToDate > date) ? false : true;
        }
    }
}
