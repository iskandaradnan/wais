using CP.UETrack.Model;
using CP.UETrack.Model.BEMS.AssetRegister;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IAssetRegisterBAL
    {
        AssetRegisterLovs Load();
        AssetRegisterModel Save(AssetRegisterModel assetRegister, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AssetRegisterModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);
		GridFilterResult GetChildAsset(int Id, SortPaginateFilter pageFilter);
        List<AssetStatusDetails> GetAssetStatusDetails(int AssetId);
        List<AssetRealTimeStatusDetails> GetAssetRealTimeStatusDetails(int AssetId);
        List<SoftwareDetails> GetSoftwareDetails(int AssetId);
        List<DefectDetails> GetDefectDetails(int AssetId);
        AssetRegisterAccessoriesMstModel GetAccessoriesGridData(int Id, int PageSize, int PageIndex);
        AssetRegisterAccessoriesMstModel SaveAccessoriesGridData(AssetRegisterAccessoriesMstModel assetRegister, out string ErrorMessage);
        GridFilterResult GetContractorVendor(int Id, SortPaginateFilter pageFilter);
        AssetRegisterLovs GetAssetSpecification(int Id);
        AssetPreRegistrationNoSearch GetTestingAndCommissioningDetails(int Id, out string ErrorMessage);
        AssetRegisterUpload Upload(ref AssetRegisterUpload model, out string ErrorMessage);
    }
}
