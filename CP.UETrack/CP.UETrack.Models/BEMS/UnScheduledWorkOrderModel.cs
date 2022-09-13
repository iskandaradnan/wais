using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class UnScheduledWorkOrderModel
    {
        public string HiddenId { get; set; }
        public int WorkOrderId { get; set; }
        public int MaintenanceType { get; set; }
        public int TypeOfWorkOrder { get; set; }
        public string LocationName { get; set; }
        public string CountingDays { get; set; }
        public int WorkOrderStatus { get; set; }
        public string WorkOrderStatusValue { get; set; }
        public string WorkOrderNo { get; set; }
        public string MaintenanceWorkNo { get; set; }
        public DateTime MaintenanceWorkDateTime { get; set; }
        public string MaintenanceDetails { get; set; }
        public int? AssetRegisterId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string UserArea { get; set; }
        public string UserLocation { get; set; }
        public string Level { get; set; }
        public string Block { get; set; }
        public string UserRole { get; set; }
        public string Model { get; set; }
        public string Manufacturer { get; set; }
        public string Engineer { get; set; }
        public int? EngineerId { get; set; }
        public string Requestor { get; set; }
        public int? RequestorId { get; set; }
        public int WorkOrderType { get; set; }
        public int WorkOrderCategory { get; set; }
        public int WorkOrderPriority { get; set; }
        public DateTime TargetDate { get; set; }
        public int? RunningHoursCapture { get; set; }

        //image Video
        public string Base64StringImage { get; set; }
        public string Base64StringVideo { get; set; }

        //CompletionInfo
        public int CompletionInfoId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int CompletedById { get; set; }
        public string CompletedBy { get; set; }
        public string CompletedByDesignation { get; set; }
        public DateTime? HandOverDate { get; set; }
        public int VerifiedById { get; set; }
        public string VerifiedBy { get; set; }
        public string VerifiedByDesignation { get; set; }
        public int? CauseCodeDescription { get; set; }
        public string CauseCode { get; set; }
        public int? QCDescription { get; set; }
        public string QCCode { get; set; }
        public string RepairDetails { get; set; }
        public int? Status { get; set; }
        public DateTime? Date { get; set; }
        public int? Reason { get; set; }
        public int IsSubmitted { get; set; }
        public string RunningHours { get; set; }
        public string ErrorMessage { get; set; }
        public string Timestamp { get; set; }

        // Part Replacement
        public DateTime? PartWorkOrderDate { get; set; }
        public decimal TotalSparePartCost { get; set; }
        public decimal TotalLabourCost { get; set; }
        public decimal TotalCost { get; set; }
        public decimal? EstimatedLifeSpan { get; set; }
        public decimal? AverageUsageHours { get; set; }


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
        public string AssessmentStaffName { get; set; }
        public DateTime AssessmentTargetDate { get; set; }

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

        public List<ScheduledWorkOrderCompletionInfoModel> CompletionInfoDets { get; set; }
        public List<ScheduledWorkOrderPartReplacementModel> PartReplacementDets { get; set; }
        public List<ScheduledWorkOrderPartReplacementPopUpModel> PartReplacementPopUpDets { get; set; }
        public List<ScheduledWorkOrderTransferModel> TransferDets { get; set; }
        public List<ScheduledWorkOrderRescheduleModel> RescheduleDets { get; set; }
        public List<ScheduledWorkOrderHistoryModel> HistoryDets { get; set; }
        public List<WOPPMCheckListQuantasksMstDetModel> PPMCheckListQuantasksMstDets { get; set; }
        public List<WOPPmChecklistCategoryDet> PPmChecklistCategoryDets { get; set; }
    }

}
