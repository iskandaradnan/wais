
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class CorrectiveActionReport
    {
        public string HiddenId { get; set; }
        public int CarId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int NotificationId { get; set; }
        public int ServiceId { get; set; }
        public string CARNumber { get; set; }        
        public DateTime CARDate { get; set; }
        public int QAPIndicatorId { get; set; }
        public string IndicatorCode { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public int? FollowupCARId { get; set; }
        public string FollowUpCARNumber { get; set; }
        public int? AssignedUserId { get; set; }
        public string AssignedUserName { get; set; }
        public string ProblemStatement { get; set; }
        public string RootCause { get; set; }
        public string Solution { get; set; }
        public int? PriorityLovId { get; set; }
        public int Status { get; set; }
        public string StatusValue { get; set; }
        public int? IssuerUserId { get; set; }
        public string IssuerUserName { get; set; }
        public DateTime? CARTargetDate { get; set; }
        public int ResponsiblePersonUserId { get; set; }
        public DateTime? VerifiedDate { get; set; }
        public int? VerifiedBy { get; set; }
        public string VerifiedByName { get; set; }
        public string Remarks { get; set; }
        public string FailureSymptomCode { get; set; }
        public int? FailureSymptomId { get; set; }
        public string CARGeneration { get; set; }
        public string Timestamp { get; set; }
        public bool IsAutoCarEdit { get; set; }
        public int? CARStatus { get; set; }
        public string CARStatusValue { get; set; }
        public string Assignee { get; set; }
        public List<CARAcitvity> activities { get; set; }
        
    }
    public class CARAcitvity
    {
        public int CarDetId { get; set; }
        public int CarId { get; set; }
        public string Activity { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime TargetDate { get; set; }
        public DateTime? CompletedDate { get; set; }
        public int? ResponsibilityId { get; set; }
        public int? ResponsiblePersonUserId { get; set; }
        public string ResponsiblePerson { get; set; }
        public bool IsDeleted { get; set; }

        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
    public class CARWorkOrderList
    {
        public List<CARWorkOrderDetails> workOrderDetails { get; set; }
    }
    public class CARWorkOrderDetails
    {
        public int AdditionalInfoId { get; set; }
        public int WorkOrderId { get; set; }
        public string MaintenanceWorkNo { get; set; }
        public int CategoryId { get; set; }
        public DateTime MaintenanceWorkDateTime { get; set; }
        public string AssetNo { get; set; }
        public int? FailureSymptomId { get; set; }
        public int? RootCauseId { get; set; }
        public string RootCauseDescription { get; set; }
        public RootCauseList rootCausesList { get; set; }
    }
    public class CARHistoryList
    {
        public List<CARHistoryDetails> historyDetails { get; set; }
    }
    public class CARHistoryDetails
    {
        public string RootCause { get; set; }
        public string Solution { get; set; }
        public string StatusValue { get; set; }
        public string Remarks { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }
    }
    public class RootCauseList
    {
        public List<RootCauses> rootCauses { get; set; }
    }
    public class RootCauses
    {
        public int RootCauseId { get; set; }
        public string RootCauseDescription { get; set; }
    }
}