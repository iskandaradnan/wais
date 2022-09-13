using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IMasterLevelDAL
    {
        LevelFacilityBlockDropdown Load();
        LevelMstViewModel Save(LevelMstViewModel userRole);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LevelMstViewModel Get(int Id);
        LevelFacilityBlockDropdown GetBlockData(int levelFacilityId);
        bool IsLevelCodeDuplicate(LevelMstViewModel userRole);
        bool IsRecordModified(LevelMstViewModel userRole);
        void Delete(int Id);
    }
}


