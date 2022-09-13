using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface ICompanyStaffMstDAL
    {
        CompanyStaffMstDropdown Load();
        StaffMstViewModel Save(StaffMstViewModel userRole);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        StaffMstViewModel Get(int Id);
        bool IsStaffEmployeeIdDuplicate(StaffMstViewModel userRole);
        bool IsRecordModified(StaffMstViewModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}


