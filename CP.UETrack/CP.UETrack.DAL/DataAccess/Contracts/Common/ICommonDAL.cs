using System.Collections.Generic;
using System.Data;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.GM;
using CP.UETrack.Model.VM;
using CP.UETrack.Model.BEMS.AssetRegister;

namespace CP.UETrack.DAL.DataAccess.Contracts
{
    public interface ICommonDAL
    {
        List<dynamic> ToDynamicList(DataTable dt);
        GridFilterResult GetAll(SortPaginateFilter pageFilter, string modelName);
        GridFilterResult MasterGetAll(SortPaginateFilter pageFilter, string modelName);
        GridFilterResult FEMSGetAll(SortPaginateFilter pageFilter, string modelName);
        GridFilterResult BEMSGetAll(SortPaginateFilter pageFilter, string modelName);

        DataTable Export(SortPaginateFilter pageFilter, string SPName);
        DataTable KPIExport(string SPName, KPIGenerationFetch KpiGenerationFetch);
        DataTable MonthlyStockRegisterExport(string SPName, ItemMonthlyStockRegisterList monthlystkRegmodel);
        DataTable VerificationOfVariationExport(string SPName, VVFEntity vvfExport);
        DataTable WarrantyHistory(string SPName, string AssetId);
        FileUploadDetModel DownloadAttachments(int dcoumentId);
        LovMasterViewModel GetHelpDescription(string ScreenUrl);
        List<HistoryViewModel> History(string GuId, int PageIndex, int PageSize);
        AssetRegisterImport GetAssetData(string AssetId);
    }

    public interface IMasterBlockDALs
    {
        BlockFacilityDropdown Load();
        BlockMstViewModel Save(BlockMstViewModel block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        GridFilterResult MasterGetAll(SortPaginateFilter pageFilter);
        BlockMstViewModel Get(int Id);
        bool IsBlockCodeDuplicate(BlockMstViewModel userRole);
        bool IsRecordModified(BlockMstViewModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }

    public interface IMasterlevelDALs
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
