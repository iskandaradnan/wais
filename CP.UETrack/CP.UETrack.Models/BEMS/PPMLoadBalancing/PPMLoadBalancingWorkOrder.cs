
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class PPMLoadBalancingWorkOrder
    {
        public int Year { get; set; }
        public int AssetClassificationId { get; set; }
        public int StaffMasterId { get; set; }
        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public int Month { get; set; }
        public int Week { get; set; }
        public int WorkOrderId { get; set; }
        public string MaintenanceWorkNo { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public DateTime TargetDateTime { get; set; }
        public DateTime? ProposedDate { get; set; }
        public int WorkOrderStatus { get; set; }
        public string WorkOrderStatusValue { get; set; }
        public string Assignee { get; set; }
        public string Timestamp { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
    public class PPMLoadBalancingWorkOrders
    {
        public List<PPMLoadBalanceTarget> WorkOrders { get; set; }
    }
    public class PPMLoadBalanceTarget
    {
        public int WorkOrderId { get; set; }
        public DateTime? TargetDateTime { get; set; }
        public int NewAssigneeId { get; set; }
        public string Timestamp { get; set; }
    }
}