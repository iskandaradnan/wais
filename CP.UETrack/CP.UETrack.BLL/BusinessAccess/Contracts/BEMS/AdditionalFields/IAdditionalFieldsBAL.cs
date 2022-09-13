using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IAdditionalFieldsBAL
    {
        AdditionalFieldsLovs Load();
        AdditionalFieldsConfig Save(AdditionalFieldsConfig AdditionalFieldsConfig, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AdditionalFieldsConfig Get(int CustomerId, int ScreenId);
        void Delete(int Id);
        AssetRegisterAdditionalFields GetAdditionalInfoForAsset(int AssetId);
        AssetRegisterAdditionalFields SaveAdditionalInfoForAsset(AssetRegisterAdditionalFields AdditionalInfo, out string ErrorMessage);
        TestingAndCommissioningAdditionalFields GetAdditionalInfoForTAndC(int TestingandCommissioningId);
        TestingAndCommissioningAdditionalFields SaveAdditionalInfoTAndC(TestingAndCommissioningAdditionalFields AdditionalInfo, out string ErrorMessage);
        workorderAdditionalFields GetAdditionalInfoForWorkorder(int WorkOrderId);
        workorderAdditionalFields SaveAdditionalInfoWorkorder(workorderAdditionalFields AdditionalInfo, out string ErrorMessage);
    }
}
