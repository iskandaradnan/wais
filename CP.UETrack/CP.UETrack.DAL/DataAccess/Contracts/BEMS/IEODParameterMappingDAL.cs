using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IEODParameterMappingDAL
    {
        EODTpeCodeMapDropdownValues Load();
        EODParameterMapping Save(EODParameterMapping EODParamCodeMapping, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        EODParameterMapping Get(int Id, int pagesize, int pageindex);
        bool IsRoleDuplicate(EODParameterMapping userRole);
        bool IsRecordModified(EODParameterMapping userRole);
        void Delete(int Id, out string ErrorMessage);
        EODParameterMapping GetHistory(int Id);
    }
}
