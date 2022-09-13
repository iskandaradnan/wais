using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IUserRoleDAL
    {
        UserRoleLovs Load();
        UMUserRole Save(UMUserRole userRole);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        UMUserRole Get(int Id);
        bool IsRoleDuplicate(UMUserRole userRole);
        bool IsRoleReferenced(UMUserRole userRole);
        bool IsRecordModified(UMUserRole userRole);
        void Delete(int Id, out string ErrorMessage);
        GridFilterResult Export(SortPaginateFilter pageFilter, string ExportType);
    }
}


