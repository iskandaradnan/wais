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
    public class FacilityStaffMstBAL : IFacilityStaffMstBAL
    {
        private string _FileName = nameof(FacilityStaffMstBAL);
        IFacilityStaffMstDAL _FacilityStaffMstDAL;
        public FacilityStaffMstBAL(IFacilityStaffMstDAL FacilityStaffMstDAL)
        {
            _FacilityStaffMstDAL = FacilityStaffMstDAL;
        }
        public FacilityStaffMstDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _FacilityStaffMstDAL.Load();
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
        public StaffMstViewModel Save(StaffMstViewModel FacilityStaffMst, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                StaffMstViewModel result = null;

                if (IsValid(FacilityStaffMst, out ErrorMessage))
                {
                    result = _FacilityStaffMstDAL.Save(FacilityStaffMst);
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
        private bool IsValid(StaffMstViewModel FacilityStaffMst, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (string.IsNullOrEmpty(FacilityStaffMst.StaffEmployeeId) || string.IsNullOrEmpty(FacilityStaffMst.StaffName) || string.IsNullOrEmpty(FacilityStaffMst.Email) || 
                string.IsNullOrEmpty(FacilityStaffMst.ContactNo) || FacilityStaffMst.UMUserRoleId == 0 || FacilityStaffMst.DepartmentId == 0 || FacilityStaffMst.DesignationId == 0)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (FacilityStaffMst.StaffMasterId == 0)
            {
                if (_FacilityStaffMstDAL.IsStaffEmployeeIdDuplicate(FacilityStaffMst))
                    ErrorMessage = "Staff/Employee ID should be unique";
                else
                    isValid = true;
            }
            //else if (_FacilityStaffMstDAL.IsRecordModified(FacilityStaffMst))
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
                var result = _FacilityStaffMstDAL.GetAll(pageFilter);
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
                var result = _FacilityStaffMstDAL.Get(Id);
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
                _FacilityStaffMstDAL.Delete(Id, out ErrorMessage);
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
