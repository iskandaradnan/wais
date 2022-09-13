using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System.Collections.Generic;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.VM;
using static CP.UETrack.Model.FetchModels.ModelSearching;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IFetchBAL
    {
        List<UMStaffSearch> FetchRecords(UMStaffSearch SearchObject);
        List<ItemMstFetchEntity> FetchItemMstdetais(ItemMstFetchEntity SearchObject);
        List<TypeCodeSearch> TypeCodeFetch(TypeCodeSearch SearchObject);
        List<Arp> ArpBerNo(Arp SearchObject);
        List<EngAssetTypeCodeStandardTasksFetch> FetchTaskCode(EngAssetTypeCodeStandardTasksFetch searchObject);
        List<UserLocationCodeSearch> LocationCodeFetch(UserLocationCodeSearch SearchObject);
        List<ManufacturerSearch> ManufacturerFetch(ManufacturerSearch SearchObject);
        List<ModelSearch> ModelFetch(ModelSearch SearchObject);
        List<ParentAssetNoSearch> FacilityWorkAssetNoFetch(ParentAssetNoSearch SearchObject);
        List<RescheduleWOFetchModel> FetchRescheduleWOdetails(RescheduleWOFetchModel SearchObject);
        List<AssetPreRegistrationNoSearch> AssetPreRegistrationNoFetch(AssetPreRegistrationNoSearch SearchObject);
        List<AssetRegisterWarrantyProviderGrid> FetchWarrantyProvider(AssetRegisterWarrantyProviderGrid SearchObject);
        List<CompanyStaffFetchModel> CompanyStaffFetch(CompanyStaffFetchModel searchObject);
        List<FacilityStaffFetchModel> FacilityStaffFetch(FacilityStaffFetchModel searchObject);
        List<LevelFetchModel> LevelCodeFetch(LevelFetchModel searchObject);
        List<WarrantyManagementSearch> AssetNoFetch(WarrantyManagementSearch SearchObject);
        List<UserAreaFetch> UserAreaFetch(UserAreaFetch searchObject);
        List<StockAdjustmentFetchModel> StockAdjustmentFetchModel(StockAdjustmentFetchModel SearchObject);
        List<ParentAssetNoSearch> ParentAssetNoFetch(ParentAssetNoSearch SearchObject);
        List<AssetClassificationFetch> AssetClassificationCodeFetch(AssetClassificationFetch searchObject);
        List<ItemCodeFetch> ItemCodeFetch(ItemCodeFetch searchObject);
        List<SNFAssetFetchEntity> SNFAssetFetch(SNFAssetFetchEntity searchObject);
        List<PPMCheckListFetchItem> FetchCheckListItemDetails(PPMCheckListFetchItem searchObject);
        List<BERAssetNoFetch> BERAssetNoFetch(BERAssetNoFetch searchObject);
        List<SNFfetchEntity> FetchSNFDetails(SNFfetchEntity searchObject);
        List<BERRejectedNoFetch> BERRejectedNoFetch(BERRejectedNoFetch searchObject);
        List<AssetQRCodePrintFetchModel> AssetQRCodePrintFetchModel(AssetQRCodePrintFetchModel SearchObject);
        List<UserLocationQRCodePrintingFetchModel> UserLocationQRCodePrintingFetchModel(UserLocationQRCodePrintingFetchModel SearchObject);
        List<UserAreaQRCodePrintingFetchModel> UserAreaQRCodePrintingFetchModel(UserAreaQRCodePrintingFetchModel SearchObject);
        List<CRMWorkorderRequestFetch> CRMWorkorderRequestFetch(CRMWorkorderRequestFetch SearchObject);
        List<TAndCCRMRequestNoFetchSearch> TAndCCRMRequestNoFetch(TAndCCRMRequestNoFetchSearch SearchObject);
        List<PortAssetFetchModel> PorteringWorkOrderNoFetch(PortAssetFetchModel searchObject);
        List<PortAssetFetchModel> PorteringAssetNoFetch(PortAssetFetchModel searchObject);

        List<EODCaptureAssetFetch> EODCaptureAssetFetch(EODCaptureAssetFetch SearchObject);
        List<EODCaptureManufacturer> EODCaptureManufacturer(EODCaptureManufacturer SearchObject);
        List<EODCaptureModel> EODCaptureModel(EODCaptureModel SearchObject);
        List<CustomerFetch> CustomerCodeFetch(CustomerFetch SearchObject);
        List<CRMRequestAssetFetch> CRMRequestAssetFetch(CRMRequestAssetFetch SearchObject);
        List<CRMWorkorderStaffFetch> CRMWorkorderStaffFetch(CRMWorkorderStaffFetch SearchObject);
        List<ContractorNameSearch> ContractorNameFetch(ContractorNameSearch SearchObject);
        List<BookingFetch> BookingWorkOrderNoFetch(BookingFetch SearchObject);
        List<BookingFetch> BookingAssetNoFetch(BookingFetch fetchObj);
        List<UserShiftLeaveDetailsFetch> UserShiftLeaveDetailsFetch(UserShiftLeaveDetailsFetch SearchObject);
        List<UserTainingParticipantFetch> UserTainingParticipantFetch(UserTainingParticipantFetch SearchObject);
        List<FilureSymptomCodeFetch> FilureSymptomCodeFetch(FilureSymptomCodeFetch SearchObject);
        List<FollowupCarFetch> FollowupCarFetch(FollowupCarFetch SearchObject);
        List<AreaFetch> BlockCascCodeFetch(AreaFetch SearchObject);
        List<AreaFetch> LevelCascCodeFetch(AreaFetch SearchObject);
        List<AreaFetch> AreaCascCodeFetch(AreaFetch SearchObject);
        List<UserLocationCodeSearch> BookingLocationFetch(UserLocationCodeSearch SearchObject);
        List<CRMRequestType> CRMFetchRequestTypedetais(CRMRequestType SearchObject);
        List<ItemMstFetchEntity> FetchItemNo(ItemMstFetchEntity SearchObject);
        List<ItemMstFetchEntity> FetchPartNo(ItemMstFetchEntity SearchObject);

        #region LLS Fetch and Search
        List<UserAreaFetch> DepartmentCascCodeFetch(UserAreaFetch searchObject);

        List<UserAreaFetchs> LLSUserAreaDetailsLocationMstDet_FetchLocCode(UserAreaFetchs searchObject);

        List<LinenItemCodeFetch> LinenItemCascCodeFetch(LinenItemCodeFetch SearchObject);
        List<LocationCodeFetch> LocationCascCodeFetch(LocationCodeFetch SearchObject);

        List<CleanLinenRequestModel> Cleanlinenrequest_UserareaCodeFetch(CleanLinenRequestModel searchObject);
        List<CleanLinenRequestModel> CleanLinenRequestTxn_FetchLocCode(CleanLinenRequestModel searchObject);
        List<CleanLinenRequestModel> Cleanlinenrequest_FetchrequestBy(CleanLinenRequestModel SearchObject);
        List<LocationCodeFetch> Cleanlinenrequestlinenitem_LinenCodeFetch(LocationCodeFetch SearchObject);

        List<LocationCodeFetch> CleanLinenRequestLinenBag_FetchLaundryBag(LocationCodeFetch SearchObject);
        List<LinenConemnationModel> LinenInjectionTxnDet_FetchLinenCode(LinenConemnationModel SearchObject);

        List<CleanLinenDespatchModel> CleanLinenDespatchTxn_FetchReceivedBy(CleanLinenDespatchModel SearchObject);

        List<CleanLinenDespatchModel> CleanLinenDespatchTxnDet_FetchLinenCode(CleanLinenDespatchModel SearchObject);

        #region CleanLinenIssue
        List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchCLRDocNo(CleanLinenIssueModel SearchObject);
        List<CleanLinenIssueModel> CleanLinenIssueTxn_Fetch1stReceivedBy(CleanLinenIssueModel SearchObject);

        List<CleanLinenIssueModel> CleanLinenIssueTxn_Fetch2ndReceivedBy(CleanLinenIssueModel SearchObject);
        List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchVerifier(CleanLinenIssueModel SearchObject);
        List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchDeliveredBy(CleanLinenIssueModel SearchObject);
        List<CleanLinenIssueModel> CleanLinenIssueLinenBagTxnDet_FetchLaundryBag(CleanLinenIssueModel SearchObject);
        #endregion
        List<DriverDetailsModel> DriverDetailsMstDet_FetchLicenseCode(DriverDetailsModel SearchObject);

        List<LinenAdjustmentsModel> LinenAdjustmentTxn_FetchAuthorisedBy(LinenAdjustmentsModel SearchObject);

        List<LinenAdjustmentsModel> LinenAdjustmentTxn_FetchInventoryDocNo(LinenAdjustmentsModel SearchObject);

        List<LinenAdjustmentsModel> LinenAdjustmentTxnDet_FetchLinenCode(LinenAdjustmentsModel SearchObject);
        List<VehicleDetailsModel> VehicleDetailsMstDet_FetchLicenseCode(VehicleDetailsModel SearchObject);
        List<LinenRepairModel> LinenRepairTxn_FetchRepairedBy(LinenRepairModel SearchObject);

        List<LinenRepairModel> LinenRepairTxn_FetchCheckedBy(LinenRepairModel SearchObject);

        List<LinenRepairModel> LinenRepairTxnDet_FetchLinenCode(LinenRepairModel SearchObject);

        List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxn_FetchYear(CentralLinenStoreHousekeepingModel SearchObject);

        List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxn_FetchMonth(CentralLinenStoreHousekeepingModel SearchObject);
        List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxnDet_FetchDate(CentralLinenStoreHousekeepingModel SearchObject);
        List<soildLinencollectionsModel> SoiledLinenCollectionTxn_FetchLaundryPlant(soildLinencollectionsModel SearchObject);

        List<CentralLinenStoreHousekeepingModel> SoiledLinenCollectionTxnDet_FetchUserAreaCode(CentralLinenStoreHousekeepingModel SearchObject);

        List<CentralLinenStoreHousekeepingModel> SoiledLinenCollectionTxnDet_FetchLocCode(CentralLinenStoreHousekeepingModel SearchObject);
        List<soildLinencollectionsModel> SoiledLinenCollectionTxnDet_FetchCollectionSchedule(soildLinencollectionsModel SearchObject);

        List<soildLinencollectionsModel> SoiledLinenCollectionTxnDet_FetchVerifiedBy(soildLinencollectionsModel SearchObject);

        List<LinenConemnationModel> LinenCondemnationTxn_FetchVerifiedBy(LinenConemnationModel SearchObject);

        List<LinenConemnationModel> LinenCondemnationTxn_FetchInspectedBy(LinenConemnationModel SearchObject);

        List<LinenConemnationModel> LinenCondemnationTxnDet_FetchLinenCode(LinenConemnationModel SearchObject);
        List<LinenRejectReplacementModel> LinenRejectReplacementTxnDet_FetchLinenCode(LinenRejectReplacementModel SearchObject);
        List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchLocCode(LinenRejectReplacementModel SearchObject);
        List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchUserAreaCode(LinenRejectReplacementModel SearchObject);
        List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchCLINo(LinenRejectReplacementModel SearchObject);
        List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchRejectedBy(LinenRejectReplacementModel SearchObject);

        List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchReceivedBy(LinenRejectReplacementModel SearchObject);
        List<LinenConemnationModel> LLSLinenInjectionTxn_FetchDONo(LinenConemnationModel SearchObject);

        List<UserAreaFetch> LLSLinenInventoryTxn_FetchUserAreaCode(UserAreaFetch SearchObject);

        List<UserAreaFetch> LLSLinenInventoryTxn_FetchVerifiedBy(UserAreaFetch SearchObject);

        List<UserAreaFetch> LLSLinenInventoryTxnDet_FetchLinenCode(UserAreaFetch SearchObject);
        List<UserAreaFetch> LLSLinenInventoryTxnDet_FetchLinenCodeUserArea(UserAreaFetch SearchObject);

        #endregion

        #region CRMRequest Asset
        List<CRMWorkorderStaffFetch> CrmAssetNoFetch(CRMWorkorderStaffFetch SearchObject);
        #endregion

        
        List<Arp> ArpAssetNo(Arp SearchObject);

        
    }
}