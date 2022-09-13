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
    public class CompanyStaffMstBAL : ICompanyStaffMstBAL
    {
        private string _FileName = nameof(CompanyStaffMstBAL);
        ICompanyStaffMstDAL _CompanyStaffMstDAL;
        public CompanyStaffMstBAL(ICompanyStaffMstDAL CompanyStaffMstDAL)
        {
            _CompanyStaffMstDAL = CompanyStaffMstDAL;
        }
        public CompanyStaffMstDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CompanyStaffMstDAL.Load();
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
        public StaffMstViewModel Save(StaffMstViewModel CompanyStaffMst, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                StaffMstViewModel result = null;

                if (IsValid(CompanyStaffMst, out ErrorMessage))
                {
                    result = _CompanyStaffMstDAL.Save(CompanyStaffMst);
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
        private bool IsValid(StaffMstViewModel CompanyStaffMst, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (string.IsNullOrEmpty(CompanyStaffMst.StaffEmployeeId) || string.IsNullOrEmpty(CompanyStaffMst.StaffName) || string.IsNullOrEmpty(CompanyStaffMst.Email) ||
                string.IsNullOrEmpty(CompanyStaffMst.ContactNo) || CompanyStaffMst.UMUserRoleId == 0 || CompanyStaffMst.EmployeeTypeLovId == 0 || string.IsNullOrEmpty(CompanyStaffMst.StaffSpecialityId))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (CompanyStaffMst.StaffMasterId == 0)
            {
                if (_CompanyStaffMstDAL.IsStaffEmployeeIdDuplicate(CompanyStaffMst))
                    ErrorMessage = "Staff/Employee ID should be unique";
                else
                    isValid = true;
            }
            //else if (_CompanyStaffMstDAL.IsRecordModified(CompanyStaffMst))
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
                var result = _CompanyStaffMstDAL.GetAll(pageFilter);
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

        public StaffMstViewModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CompanyStaffMstDAL.Get(Id);
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
                _CompanyStaffMstDAL.Delete(Id, out ErrorMessage);
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
