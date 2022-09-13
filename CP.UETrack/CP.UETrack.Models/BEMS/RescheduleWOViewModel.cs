using System;
using System.Collections.Generic;
using CP.UETrack.Models;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class RescheduleWOViewModel
    {
        public List<RescheduleWOListData> RescheduleWOListData { get; set; }
        public int WorkOrderReschedulingId { get; set; }
        public List<LovValue> ReasonData { get; set; }
        public int WorkOrderId { get; set; }
        public string WorkOrderNo { get; set; }
        public DateTime NextScheduleDate { get; set; }
        public DateTime RescheduleDate { get; set; }
        public int NotificationId { get; set; }
        public int RescheduleApprovedBy { get; set; }
        public int ReasonForReschedule { get; set; }
        public int StaffMasterId { get; set; }
        public string Email { get; set; }
        public string StaffName { get; set; }
        public int NewStaffMasterId { get; set; }
        public string NewStaffName { get; set; }
        public int? UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public int? UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int? PlannerId { get; set; }
        public string TypeOfPlanner { get; set; }
        public string TypeOfWorkOrderName { get; set; }
        public string MaintenanceDetails { get; set; }
        public string Reason { get; set; }
        public string LocationName { get; set; }
        public string Assignee { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public int? AssetId { get; set; }
    }

    public class RescheduleWOListData
    {
        public int WorkOrderReschedulingId { get; set; }
        public int? WorkOrderId { get; set; }
        public string WorkOrderNo { get; set; }
        public DateTime WorkOrderDate { get; set; }
        public int? AssetId { get; set; }
        public string AssetNo { get; set; }
        public int NewStaffMasterId { get; set; }
        public string NewStaffName { get; set; }
        public string AssetDescription { get; set; }
        public int TypeOfWorkOrderId { get; set; }
        public string TypeOfWorkOrderName { get; set; }
        public string MaintenanceDetails { get; set; }
        public DateTime TargetDate { get; set; }
        public DateTime NextScheduleDate { get; set; }
        public DateTime? RescheduleDate { get; set; }
        public DateTime? scheduleDate { get; set; }
        public int RescheduleApprovedBy { get; set; }
        public string RescheduleApprovedByName { get; set; }
        public int ReasonForReschedule { get; set; }
        public string ReasonForRescheduleName { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool BuiltIn { get; set; }
        public bool IsDeleted { get; set; }
        public string GuId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public string Reason { get; set; }
       
    }

    public class RescheduleDropdownValues
    {
        public List<LovValue> PlannerLovs { get; set; }
        public List<LovValue> Reason { get; set; }
    }

    public class RescheduleWOFetchModel
    {
        public int WorkOrderId { get; set; }
        public string WorkOrderNo { get; set; }
        public DateTime WorkOrderDate { get; set; }
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public int TypeOfWorkOrderId { get; set; }
        public string TypeOfWorkOrderName { get; set; }
        public string MaintenanceDetails { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? NextScheduleDate { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string LocationName { get; set; }
        public string Assignee { get; set; }
    }
}
