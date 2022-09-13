using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.AssetRegister;
using CP.UETrack.Model.GM;
using CP.UETrack.Model.VM;
using System.Collections.Generic;
using System.Data;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.Common
{
    public interface ICommonBAL
    {
        GridFilterResult GetAll(SortPaginateFilter pageFilter, string modelName);
        
        GridFilterResult FEMSGetAll(SortPaginateFilter pageFilter, string modelName);
        GridFilterResult BEMSGetAll(SortPaginateFilter pageFilter, string modelName);
        GridFilterResult MasterGetAll(SortPaginateFilter pageFilter, string modelName);
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

    public interface IMasterBlockBALs
    {
        BlockFacilityDropdown Load();
        BlockMstViewModel Save(BlockMstViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        GridFilterResult MasterGetAll(SortPaginateFilter pageFilter);
        BlockMstViewModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }


    public interface IMasterlevelBALs
    {
        LevelFacilityBlockDropdown Load();
        LevelMstViewModel Save(LevelMstViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LevelMstViewModel Get(int Id);
        LevelFacilityBlockDropdown GetBlockData(int levelFacilityId);
        void Delete(int Id);
    }

}
