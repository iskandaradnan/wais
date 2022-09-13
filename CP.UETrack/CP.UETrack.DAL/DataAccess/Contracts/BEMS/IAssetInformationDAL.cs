using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IAssetInformationDAL
    {
        BlockFacilityDropdown Load();
        AssetInformationViewModel Save(AssetInformationViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AssetInformationViewModel Get(int Id, int AssetInfoType);
        bool IsRoleDuplicate(AssetInformationViewModel userRole);
        bool IsRecordModified(AssetInformationViewModel userRole);
        void Delete(int Id, int AssetInfoType);
    }
}


