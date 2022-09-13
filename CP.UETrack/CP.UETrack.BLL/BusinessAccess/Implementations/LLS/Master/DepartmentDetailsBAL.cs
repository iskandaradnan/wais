using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.Model.LLS;
using CP.UETrack.DAL.DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Master;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS.Master
{
    public class DepartmentDetailsBAL : IDepartmentDetailsBAL
    {
        private string _FileName = nameof(DepartmentDetailsBAL);
        IDepartmentDetailsDAL _DepartmentDetailsDAL;
        private readonly IUserAreaDAL _userAreaDAL;
        public DepartmentDetailsBAL(IDepartmentDetailsDAL DepartmentDetailsDAL)
        {
            _DepartmentDetailsDAL = DepartmentDetailsDAL;
        }
        public DepartmentDetailsModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _DepartmentDetailsDAL.Load();
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
        public DepartmentDetailsModel Save(DepartmentDetailsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                DepartmentDetailsModel result = null;
                if (IsValid(model, out ErrorMessage))
                {
                    result = _DepartmentDetailsDAL.Save(model, out ErrorMessage);
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

        public DepartmentDetailsModel Get(int Id/*, int pagesize, int pageindex*/)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _DepartmentDetailsDAL.Get(Id/*, pagesize, pageindex*/);
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

        public string CheckUserAreaCode(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CheckUserAreaCode), Level.Info.ToString());
                string ErrorMessage = "";
                DepartmentDetailsModel model = new DepartmentDetailsModel();
             
                model.UserAreaCode = Id;
                model.UserAreaName = " ";
                string ErrorMessage1 = "";
                if (!Valid(model, out ErrorMessage1))
                  ErrorMessage = ErrorMessage1;
                Log4NetLogger.LogExit(_FileName, nameof(CheckUserAreaCode), Level.Info.ToString());
                return ErrorMessage;
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
        private bool Valid(DepartmentDetailsModel model, out string ErrorMessage)
        {

            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(model.UserAreaCode) || string.IsNullOrEmpty(model.UserAreaName))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }

            else if (_DepartmentDetailsDAL.IsUserAreaDuplicate(model))
            {
                ErrorMessage = "User Area Code already exists";
            }
            //else if (_DepartmentDetailsDAL.IsRecordModified(model))
            //{
            //    ErrorMessage = "Record Modified. Please Re-Select";
            //}

            else
            {
                //isValid = true;
            }
            return isValid;
        }
        private bool IsValid(DepartmentDetailsModel model, out string ErrorMessage)
        {

            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(model.UserAreaCode) || string.IsNullOrEmpty(model.UserAreaName))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }

            else if (_DepartmentDetailsDAL.IsUserAreaDuplicate(model))
            {
                ErrorMessage = "User Area Code already exists";
            }
            //else if (_DepartmentDetailsDAL.IsRecordModified(model))
            //{
            //    ErrorMessage = "Record Modified. Please Re-Select";
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
                var result = _DepartmentDetailsDAL.GetAll(pageFilter);
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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _DepartmentDetailsDAL.Delete(Id, out ErrorMessage);
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

        public DepartmentDetailsModel LinenItemSave(DepartmentDetailsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LinenItemSave), Level.Info.ToString());

                ErrorMessage = string.Empty;
                DepartmentDetailsModel result = null;
                //if (IsValid(model, out ErrorMessage))
                //{
                    result = _DepartmentDetailsDAL.LinenItemSave(model, out ErrorMessage);
                //}

                Log4NetLogger.LogExit(_FileName, nameof(LinenItemSave), Level.Info.ToString());
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
 

