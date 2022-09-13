using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IEODTypeCodeMappingDAL
    {
        EODDropdownValues Load();
        EODTypeCodeMappingViewModel Save(EODTypeCodeMappingViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        EODTypeCodeMappingViewModel Get(int Id, int pagesize, int pageindex);
        bool IsRoleDuplicate(EODTypeCodeMappingViewModel userRole);
        bool IsRecordModified(EODTypeCodeMappingViewModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}


