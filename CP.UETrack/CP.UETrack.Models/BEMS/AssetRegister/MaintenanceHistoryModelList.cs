using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class MaintenanceHistoryModelList
    {
        public List<MaintenanceHistoryModel> maintenanceHistory { get; set; }
        public List<PartsDetails> partsDetails { get; set; }
    }
    public class MaintenanceHistoryModel
    {
        public int WorkOrderId { get; set; }
        public string MaintenaceWorkNo { get; set; }
        public DateTime? WorkOrderDate { get; set; }
        public int CategoryId { get; set; }
        public string WorkCategory { get; set; }
        public string Type { get; set; }
        public decimal? TotalDownTime { get; set; }
        public decimal? SparepartsCost { get; set; }
        public decimal? LabourCost { get; set; }
        public decimal? TotalCost { get; set; }
    }
    public class PartsDetails
    {
        public int WorkOrderId { get; set; }
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
