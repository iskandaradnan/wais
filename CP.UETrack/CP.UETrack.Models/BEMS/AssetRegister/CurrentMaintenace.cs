using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class CurrentMaintenance
    {
        public List<PPMMaintenance> ppmMaintenance { get; set; }
        public List<UnScheduleMaintenance> unScheduleMaintenance { get; set; }
        public List<QCMaintenance> qcMaintenance { get; set; }
    }
    public class PPMMaintenance
    {
        public int WorkOrderId { get; set; }
        public string MaintenaceWorkNo { get; set; }
        public DateTime? WorkOrderDate { get; set; }
        public int CategoryId { get; set; }
        public string WorkCategory { get; set; }
        public string Type { get; set; }
        
    }
    public class UnScheduleMaintenance
    {
        public int WorkOrderId { get; set; }
        public string MaintenaceWorkNo { get; set; }
        public int CategoryId { get; set; }
        public DateTime? WorkOrderDate { get; set; }
        public string WorkCategory { get; set; }
        public string Type { get; set; }
    }
    public class QCMaintenance
    {
        public string MaintenaceWorkNo { get; set; }
        public DateTime? WorkOrderDate { get; set; }
        public string WorkCategory { get; set; }
        public string Type { get; set; }
        //public decimal? TotalDownTime { get; set; }
        //public decimal? SparepartsCost { get; set; }
        //public decimal? ServiceCost { get; set; }
        //public decimal? LabourCost { get; set; }
        //public decimal? TotalCost { get; set; }
        //public MaintenanceHistory maintenanceHistory { get; set; }
    }
    public class MaintenanceHistory
    {
        public string PartNo { get; set; }
        public string PartDescription { get; set; }
        public string ItemNo { get; set; }
        public string ItemDescription { get; set; }
        public decimal? MinCost { get; set; }
        public decimal? MaxCost { get; set; }
        public decimal? Quantity { get; set; }
        public decimal? CostPerUnit { get; set; }
        public string StockType { get; set; }
    }
}
