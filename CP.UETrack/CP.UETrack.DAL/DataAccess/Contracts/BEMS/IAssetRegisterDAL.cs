using CP.UETrack.Model;
using CP.UETrack.Model.BEMS.AssetRegister;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IAssetRegisterDAL
    {
        AssetRegisterLovs Load();
        AssetRegisterModel Save(AssetRegisterModel assetRegister, out string ErrorMessage);
        AssetRegisterUploadModel SaveUpload(AssetRegisterUploadModel assetRegister, out string ErrorMessage);        
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AssetRegisterModel Get(int Id);
        bool IsAssetNoDuplicate(AssetRegisterModel assetRegister);
        bool IsSerialNoDuplicate(AssetRegisterModel assetRegister);
        void Delete(int Id, out string ErrorMessage);
        GridFilterResult GetChildAsset(int Id, SortPaginateFilter pageFilter);
        List<AssetStatusDetails> GetAssetStatusDetails(int AssetId);
        List<AssetRealTimeStatusDetails> GetAssetRealTimeStatusDetails(int AssetId);
        List<SoftwareDetails> GetSoftwareDetails(int AssetId);
        List<DefectDetails> GetDefectDetails(int AssetId);
        AssetRegisterAccessoriesMstModel GetAccessoriesGridData(int Id, int pagesize, int pageindex);
        AssetRegisterAccessoriesMstModel SaveAccessoriesGridData(AssetRegisterAccessoriesMstModel Accessories, out string ErrorMessage);
        GridFilterResult GetContractorVendor(int Id, SortPaginateFilter pageFilter);
        AssetRegisterLovs GetAssetSpecification(int Id);
        AssetPreRegistrationNoSearch GetTestingAndCommissioningDetails(int Id, out string ErrorMessage);
        AssetRegisterUploadModel ImportValidation(ref AssetRegisterUploadModel model);
    }
}


