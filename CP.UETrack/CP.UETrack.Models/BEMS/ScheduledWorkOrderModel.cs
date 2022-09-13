using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class ScheduledWorkOrderModel
    {
        //Search Filters
        //public string Remarks { get; set; }
        public decimal PopUpQuantityAvailable { get; set; }
        public decimal PopUpQuantityTaken { get; set; }
        public string AssetClassificationDescription { get; set; }
        public string WorkOrderPriorityValue { get; set; }
        public string MaintenanceWorkNo { get; set; }
        public string Department { get; set; }
        public string MaintenanceWorkDateTime { get; set; }
        public string TargetDateTime { get; set; }
        public string CountOfDays { get; set; }
        public string CountingDays { get; set; }
        public string ContractTypeValue { get; set; }
        public string LocationName { get; set; }
        public decimal TotalPartReplacementCost { get; set; }
        public string Email { get; set; }
        public string BreakdownDetails { get; set; }
        public string TypeOfWorkOrderGrid { get; set; }
        public string WorkOrderStatusGrid { get; set; }
        public string WorkOrderCategoryGrid { get; set; }
        public string WorkOrderPriorityGrid { get; set; }
        public string Assignee { get; set; }
        public int? AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string TypeCode { get; set; }
        public string TypeCodeDescription { get; set; }
        public string WorkOrderAssignee { get; set; }
        public int WorkOrderAssigneeId { get; set; }
        public string HiddenId { get; set; }
        public int WorkOrderId { get; set; }
        public int MaintenanceType { get; set; }
        public string MaintenanceTypeVaule { get; set; }
        public int TypeOfWorkOrder { get; set; }
        public int WorkOrderStatus { get; set; }
        public string WorkOrderStatusValue { get; set; }
        public string AssetWorkingStatusValue { get; set; }
        public string WorkOrderNo { get; set; }
        public string MaintenanceDetails { get; set; }
        public int? AssetRegisterId { get; set; }
        public string AssetNo { get; set; }
        public string AssetName { get; set; }
        public string AssetNoCost { get; set; }
        public string AssetDescription { get; set; }
        public string UserArea { get; set; }
        public string UserLocation { get; set; }
        public string Level { get; set; }
        public string Block { get; set; }
        public string PorteringNo { get; set; }
        public string PorteringAssetNo { get; set; }
        public string UserRole { get; set; }
        public string Model { get; set; }
        public string Manufacturer { get; set; }
        public string Engineer { get; set; }
        public int? EngineerId { get; set; }
        public string Requestor { get; set; }
        public int? RequestorId { get; set; }
        public int WorkOrderType { get; set; }
        public int WorkOrderCategory { get; set; }
        public int WorkGroupVaule { get; set; }
        public string WorkOrderCategoryType { get; set; }
        public string TypeOfPlanner { get; set; }

        public int WorkOrderPriority { get; set; }
        public DateTime? TargetDate { get; set; }
        public int? RunningHoursCapture { get; set; }
        public int? TemplateId { get; set; }
        public DateTime ReScheduledDate { get; set; }

        public int Criticality { get; set; }

        //image Video
        public string Base64StringImage { get; set; }
        public string Base64StringVideo { get; set; }
        public string Base64StringSignature { get; set; }

        //CompletionInfo
        public int CompletionInfoId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime StartDateMain { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? EndDateMain { get; set; }
        public int CompletedById { get; set; }
        public string CompletedBy { get; set; }
        public string CompletedByDesignation { get; set; }
        public DateTime? HandOverDate { get; set; }
        public int? VerifiedById { get; set; }
        public string VerifiedBy { get; set; }
        public string VerifiedByDesignation { get; set; }
        public int? CauseCodeDescription { get; set; }
        public string CauseCode { get; set; }
        public string QCCodeFieldVaule { get; set; }
        public int? QCDescription { get; set; }
        public string QCCode { get; set; }
        public string RepairDetails { get; set; }
        public int? Status { get; set; }
        public DateTime? Date { get; set; }
        public DateTime? AgreedDate { get; set; }
        public int? Reason { get; set; }
        public int IsSubmitted { get; set; }
        public decimal? VendorServicecost { get; set; }
        public string RunningHours { get; set; }
        public decimal? DownTimeHours { get; set; }
        public string ErrorMessage { get; set; }
        public string Timestamp { get; set; }
        public int AccessLevel { get; set; }
        public string UserLocationName { get; set; }
        public string AssetStatus { get; set; }
        public string AssetCrticality { get; set; }

        public string VariationStatus { get; set; }
        public string AssetCondition { get; set; }
        public string SerialNo { get; set; }
        public Decimal ServiceLife { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public string WorkGroup { get; set; }
        public string MobileNumber { get; set; }
        public string UserAreaName { get; set; }

        public string RequesterDesignation { get; set; }
        public string AssigneeDesignation { get; set; }

        // Part Replacement
        public DateTime? PartWorkOrderDate { get; set; }
        public decimal TotalSparePartCost { get; set; }
        public decimal? TotalLabourCost { get; set; }
        public decimal TotalCost { get; set; }
        public decimal TotalVendorCost { get; set; }
        public decimal ScheduleTotalLabourCost { get; set; }
        public decimal ScheduleTotalCost { get; set; }
        public int? EstimatedLifeSpan { get; set; }
        public decimal? AverageUsageHours { get; set; }
        public int PartReplacementCostInvolved { get; set; }
        public decimal? PartReplacementCost { get; set; }
        // Transfer
        public int WOTransferId { get; set; }
        public string TransferAssetNo { get; set; }
        public string TransferAssetDescription { get; set; }
        public string TransferTypeCode { get; set; }
        public string TransferService { get; set; }
        public string TransferAssignedPerson { get; set; }
        public int TransferAssignedPersonId { get; set; }
        public int? TransferReason { get; set; }


        // Reschedule
        public string RescheduleWorkOrderNo { get; set; }
        public DateTime RescheduleWorkOrderDate { get; set; }
        public string RescheduleAssetNo { get; set; }
        public DateTime RescheduleTargetDate { get; set; }
        public DateTime RescheduleDate { get; set; }
        public int hdnRescheduleById { get; set; }


        // History
        public string HistoryWorkOrderNo { get; set; }
        public DateTime HistoryWorkOrderDate { get; set; }
        public string HistoryAssetNo { get; set; }


        // Assessment
        public int AssessmentId { get; set; }
        public int? RealTimeStatus { get; set; }
        public string AssessmentFeedBack { get; set; }
        public DateTime AssessmentResponsedate { get; set; }
        public string AssessmentResponseDuration { get; set; }
        public decimal? AssessmentResponseDurationTime { get; set; }
        public string AssessmentStaffName { get; set; }
        public DateTime AssessmentTargetDate { get; set; }
        public int? IsAssignedToVendor { get; set; }
        public int? AssignedVendor { get; set; }
        public string AssignedVendorName { get; set; }
        public string AssignedVendorEmail { get; set; }
        public string VendorProFlag { get; set; }
        public string VendorProStatus { get; set; }

        // PPM CheckList
        public int WOPPMCheckListId { get; set; }
        public int PPMCheckListId { get; set; }
        public int ServiceId { get; set; }
        public int? PPMCheckListAssetTypeCodeId { get; set; }
        public string PPMCheckListAssetTypeCode { get; set; }
        public string PPMCheckListAssetTypeDescription { get; set; }
        public string PPMCheckListTaskCode { get; set; }
        public string PPMCheckListTaskCodeDesc { get; set; }
        public string PPMCheckListPPMChecklistNo { get; set; }
        public int? PPMCheckListManufacturerId { get; set; }
        public string PPMCheckListManufacturer { get; set; }
        public int? PPMCheckListModelId { get; set; }
        public string PPMCheckListModel { get; set; }
        public string PPMCheckListPPMFrequency { get; set; }
        public decimal PPMCheckListPpmHours { get; set; }
        public string PPMCheckListSpecialPrecautions { get; set; }
        public string PPMCheckListRemarks { get; set; }
        public string PPMCheckListTimestamp { get; set; }
        public bool PPMCheckListActive { get; set; }
        public int PPMCheckListNoId { get; set; }
        public string PPMCheckListNo { get; set; }
        public int NotificationId { get; set; }
        public int? CustomerFeedback { get; set; }
        public List<LovValue> QCCodeListBased { get; set; }
        public List<ScheduledWorkOrderCompletionInfoModel> CompletionInfoDets { get; set; }
        public List<ScheduledWorkOrderPartReplacementModel> PartReplacementDets { get; set; }
        public List<ScheduledWorkOrderPartReplacementPopUpModel> PartReplacementPopUpDets { get; set; }
        public List<ScheduledWorkOrderFeedbackPopUpDetModel> FeedbackPopUpDets { get; set; }
        public List<ScheduledWorkOrderPurchaseRequestPopUpDetModel> PurchaseRequestDets { get; set; }
        public List<ScheduledWorkOrderTransferModel> TransferDets { get; set; }
        public List<ScheduledWorkOrderRescheduleModel> RescheduleDets { get; set; }
        public List<ScheduledWorkOrderHistoryModel> HistoryDets { get; set; }
        public List<WOPPMCheckListQuantasksMstDetModel> PPMCheckListQuantasksMstDets { get; set; }
        public List<WOPPmChecklistCategoryDet> PPmChecklistCategoryDets { get; set; }


    }


    public class ScheduledWorkOrderLovs
    {
        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> WarrentyTypeList { get; set; }
        public List<LovValue> StatusList { get; set; }
        public List<LovValue> ReasonList { get; set; }
        public List<LovValue> TypeOfPlannerList { get; set; }
        public List<LovValue> QCCodeList { get; set; }
        public List<LovValue> CauseCodeList { get; set; }

        public List<LovValue> CauseCode { get; set; }
        public List<LovValue> TransferReasonList { get; set; }
        public List<LovValue> WorkOrderCategoryList { get; set; }
        public List<LovValue> WorkOrderPriorityList { get; set; }
        public List<LovValue> RealTimeStatusList { get; set; }
        public List<LovValue> PPMCheckListNoIdList { get; set; }
        public List<LovValue> StockTypeList { get; set; }
        public List<LovValue> PPMCheckListStatusList { get; set; }
        public List<LovValue> PPMCheckListStatusCategoryList { get; set; }
        public List<LovValue> PartReplacementCostInvolvedList { get; set; }
        public List<LovValue> CustomerFeedbak { get; set; }
        public List<LovValue> TypeofContractList { get; set; }
        public bool IsAdditionalFieldsExist { get; set; }
        public bool IsExternal { get; set; }

        public List<LovValue> Reason { get; set; }
        public List<LovValue> Criticality { get; set; }

        public List<LovValue> WorkGroupVaule { get; set; }

    }

    public class ScheduledWorkOrderCompletionInfoModel
    {
        public int CompletionInfoDetId { get; set; }
        public int CompletionInfoId { get; set; }
        public bool IsDeleted { get; set; }
        public int StaffMasterId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public int? StandardTaskDetId { get; set; }
        public string TaskCode { get; set; }
        public string TaskDescription { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal? PPMHours { get; set; }
        public decimal CostPerHour { get; set; }
        public decimal PopUpQuantityAvailable { get; set; }
        public string PPMHoursTiming { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }

    }

    public class ScheduledWorkOrderPartReplacementModel
    {
        public int WorkOrderId { get; set; }
        public int ServiceId { get; set; }
        public int StaffMasterId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int StockUpdateDetId { get; set; }
        public int PartReplacementId { get; set; }
        public int SparePartStockRegisterId { get; set; }
        public string PartNo { get; set; }
        public string PartDescription { get; set; }
        public string ItemNo { get; set; }
        public string ItemDescription { get; set; }
        public int? EstimatedLifeSpan { get; set; }
        public int? LifeSpanOptionId { get; set; }
        public string EstimatedLifeSpanOption { get; set; }
        public DateTime? EstimatedLifeSpanDate { get; set; }
        public int? StockType { get; set; }
        public decimal Quantity { get; set; }
        public decimal PopUpQuantityAvailable { get; set; }
        public decimal PopUpQuantityTaken { get; set; }
        public decimal? AverageUsageHours { get; set; }
        public decimal CostPerUnit { get; set; }
        public string InvoiceNo { get; set; }
        public string VendorName { get; set; }
        public decimal LabourCost { get; set; }
        public decimal TotalCost { get; set; }
        public decimal TotalVendorCost { get; set; }
        public decimal ScheduleTotalLabourCost { get; set; }
        public decimal ScheduleTotalCost { get; set; }
        public bool IsDeleted { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
        public int PartReplacementCostInvolved { get; set; }
        public decimal? PartReplacementCost { get; set; }
    }

    public class ScheduledWorkOrderPartReplacementPopUpModel
    {
        public int WorkOrderId { get; set; }
        public int StockUpdateDetId { get; set; }
        public int PartReplacementId { get; set; }
        public int SparePartStockRegisterId { get; set; }
        public string PopUpPartNo { get; set; }
        public string PopUpPartDescription { get; set; }
        public decimal PopUpQuantityAvailable { get; set; }
        public decimal PopUpCostPerUnit { get; set; }
        public string PopUpInvoiceNo { get; set; }
        public string PopUpVendorName { get; set; }
        public string PopUpQuantityTaken { get; set; }
        public bool PopUpSelected { get; set; }
    }
    public class ScheduledWorkOrderFeedbackPopUpDetModel
    {
        public int AssessmentHistoryId { get; set; }
        public int AssessmentId { get; set; }
        public int SNo { get; set; }
        public string Remarks { get; set; }
        public string DoneBy { get; set; }
        public string DoneByDesignation { get; set; }
        public DateTime? Date { get; set; }
        public string Status { get; set; }
        public int StatusId { get; set; }
    }

    public class ScheduledWorkOrderPurchaseRequestPopUpDetModel
    {
        public int PurchaseRequestId { get; set; }
        public string PurchasePartNo { get; set; }
        public string PurchasePartDescription { get; set; }
        public string PurchaseItemCode { get; set; }
        public string PurchaseItemDescription { get; set; }
        public int PurchaseSparePartStockRegisterId { get; set; }
        public int WorkOrderId { get; set; }
        public string WorkOrderNo { get; set; }
        public int PurchaseQuantity { get; set; }
    }

    public class ScheduledWorkOrderTransferModel
    {
        public int WOTransferId { get; set; }
        public int WorkOrderId { get; set; }
        public int ServiceId { get; set; }
        public int StaffMasterId { get; set; }
        public string TransferWorkOrderNo { get; set; }
        public DateTime TransferWorkOrderDate { get; set; }
        public string TransferWorkOrderCategory { get; set; }
        public string TransferGridAssignedPerson { get; set; }
        public DateTime TransferAssignedDate { get; set; }
        public int TransferAssignedPersonId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
    }

    public class ScheduledWorkOrderRescheduleModel
    {
        public DateTime RescheduleDate { get; set; }
        public string RescheduleApprovedby { get; set; }
        public string RescheduleReason { get; set; }
        public string RescheduleImpactSchedulePlanner { get; set; }
        public int hdnRescheduleById { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
        //public string Reason { get; set; }
        //public string Remarks { get; set; }
    }
    public class ScheduledWorkOrderHistoryModel
    {
        public DateTime HistoryDate { get; set; }
        public string HistoryAssignedPerson { get; set; }
        public string HistoryAssignedPersonDesig { get; set; }
        public string HistoryStatus { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
    }
    public class WOPPMCheckListQuantasksMstDetModel
    {
        public int PPMCheckListHisroryQNId { get; set; }
        public int WOPPMCheckListQNId { get; set; }
        public int PPMCheckListQNId { get; set; }
        public int PPMCheckListId { get; set; }
        public int? Status { get; set; }
        public string Remarks { get; set; }
        public string Value { get; set; }
        public string QuantitativeTasks { get; set; }
        public string UOM { get; set; }
        public string SetValues { get; set; }
        public string LimitTolerance { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
    }

    public class WOPPmChecklistCategoryDet
    {
        public int PPmCategoryHisrtoryDetId { get; set; }
        public int WOPPmCategoryDetId { get; set; }
        public int PPmCategoryDetId { get; set; }
        public int? Status { get; set; }
        public string Remarks { get; set; }
        public string PpmCategoryId { get; set; }
        public int SNo { get; set; }
        public string Description { get; set; }
        public bool Active { get; set; }
        public string PPmCategory { get; set; }
    }



}
