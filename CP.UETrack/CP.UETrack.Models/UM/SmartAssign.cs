using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.UM
{
    public class SmartAssign
    {
        public int WorkOrderId { get; set; }
        public string CustomerName { get; set; }
        public string FacilityName { get; set; }
        public int CountingDays { get; set; }
        public string MaintenanceWorkNo { get; set; }
        public DateTime? MaintenanceWorkDateTime { get; set; }
        public string AssetNo { get; set; }
        public string TypeOfWorkOrder { get; set; }
        public string WorkGroupCode { get; set; }
        public DateTime? TargetDateTime { get; set; }
        public string WorkOrderPriority { get; set; }
        public string WorkOrderStatus { get; set; }
        public string MaintenanceDetails { get; set; }
        public string PorteringNo { get; set; }
        public string PorteringStatus { get; set; }
        public string AssigneeType { get; set; }
        public string AssignedName { get; set; }
        public string PorteringStatusValue { get; set; }
    }
}
