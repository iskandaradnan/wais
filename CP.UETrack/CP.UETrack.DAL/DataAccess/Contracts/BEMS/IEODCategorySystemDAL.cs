using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IEODCategorySystemDAL
    {
        EODCategorySystemViewModel Load();
        EODCategorySystemViewModel Save(EODCategorySystemViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        EODCategorySystemViewModel Get(int Id);
        bool IsRoleDuplicate(EODCategorySystemViewModel userRole);
        bool IsRecordModified(EODCategorySystemViewModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}


