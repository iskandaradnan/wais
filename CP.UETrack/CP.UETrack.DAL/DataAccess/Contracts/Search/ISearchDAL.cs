using CP.UETrack.Model;
using System.Collections.Generic;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.FetchModels;

namespace CP.UETrack.DAL.DataAccess
{
    public interface ISearchDAL
    {
        List<UMStaffSearch> StaffMasterSearch(UMStaffSearch SearchObject);
        List<TypeCodeSearch> TypeCodeSearch(TypeCodeSearch SearchObject);
        List<UserLocationCodeSearch> LocationCodeSearch(UserLocationCodeSearch SearchObject);
        List<ManufacturerSearch> ManufacturerSearch(ManufacturerSearch SearchObject);
        List<ModelSearch> ModelSearch(ModelSearch SearchObject);
        List<EngAssetTypeCodeStandardTasksFetch> TaskCodeSearch(EngAssetTypeCodeStandardTasksFetch searchObject);
        List<AssetPreRegistrationNoSearch> AssetPreRegistrationNoSearch(AssetPreRegistrationNoSearch SearchObject);
        List<LevelFetchModel> LevelCodeSearch(LevelFetchModel searchObject);
        List<CompanyStaffFetchModel> CompanyStaffSearch(CompanyStaffFetchModel searchObject);
        List<FacilityStaffFetchModel> FacilityStaffSearch(FacilityStaffFetchModel searchObject);
        List<WarrantyManagementSearch> WarrantyManagementSearch(WarrantyManagementSearch SearchObject);
        List<UserAreaFetch> UserAreaSearch(UserAreaFetch searchObject);
        List<StockAdjustmentFetchModel> StockAdjustmentFetchModel(StockAdjustmentFetchModel SearchObject);
        List<ParentAssetNoSearch> AssetNoSearch(ParentAssetNoSearch SearchObject);
        List<AssetRegisterWarrantyProviderGrid> SearchforContractorcode(AssetRegisterWarrantyProviderGrid SearchObject);
        List<AssetClassificationFetch> AssetClassificationCodeSearch(AssetClassificationFetch searchObject);
        List<ItemCodeFetch> ItemCodeSearch(ItemCodeFetch searchObject);
        List<BERAssetNoFetch> BERAssetSearch(BERAssetNoFetch searchObject);
        List<BERRejectedNoFetch> BERRejectedNoSearch(BERRejectedNoFetch searchObject);
        List<AssetQRCodePrintFetchModel> AssetQRCodePrintFetchModel(AssetQRCodePrintFetchModel SearchObject);
        List<UserLocationQRCodePrintingFetchModel> UserLocationQRCodePrintingFetchModel(UserLocationQRCodePrintingFetchModel SearchObject);
        List<CRMWorkorderRequestFetch> CRMWorkorderRequestFetch(CRMWorkorderRequestFetch SearchObject);
        List<TAndCCRMRequestNoFetchSearch> TAndCCRMRequestNoSearch(TAndCCRMRequestNoFetchSearch SearchObject);
        List<PortAssetFetchModel> PorteringWorkOrderNoSearch(PortAssetFetchModel searchObject);
        List<PortAssetFetchModel> PorteringAssetNoSearch(PortAssetFetchModel searchObject);
        List<EODCaptureAssetFetch> EODCaptureAssetFetch(EODCaptureAssetFetch SearchObject);
        List<EODCaptureManufacturer> EODCaptureManufacturer(EODCaptureManufacturer SearchObject);
        List<EODCaptureModel> EODCaptureModel(EODCaptureModel SearchObject);
        List<CustomerFetch> CustomerCodeSearch(CustomerFetch SearchObject);
        List<CRMRequestAssetFetch> CRMRequestAssetFetch(CRMRequestAssetFetch SearchObject);
        List<CRMWorkorderStaffFetch> CRMWorkorderStaffFetch(CRMWorkorderStaffFetch SearchObject);
        List<ContractorNameSearch> ContractorNameSearch(ContractorNameSearch SearchObject);
        List<BookingFetch> BookingAssetNoSearch(BookingFetch searchObject);
        List<BookingFetch> BookingWorkOrderNoSearch(BookingFetch searchObject);
        List<UserShiftLeaveDetailsFetch> UserShiftLeaveDetailsSearch(UserShiftLeaveDetailsFetch SearchObject);
        List<UserTainingParticipantFetch> UserTainingParticipantFetch(UserTainingParticipantFetch SearchObject);
        List<FilureSymptomCodeFetch> FilureSymptomCodeFetch(FilureSymptomCodeFetch SearchObject);
        List<AreaFetch> BlockCascCodeSearch(AreaFetch SearchObject);

        List<AreaFetch> QCPPMCodeSearch(AreaFetch SearchObject);
        List<AreaFetch> LevelCascCodeSearch(AreaFetch SearchObject);
        List<AreaFetch> AreaCascCodeSearch(AreaFetch SearchObject);
        List<FollowupCarFetch> FollowupCarFetch(FollowupCarFetch SearchObject);
        List<UserLocationCodeSearch> BookingLocationSearch(UserLocationCodeSearch SearchObject);

        //List<BERNoList> BERNoList(BERNoList SearchObject);
    }//
}


