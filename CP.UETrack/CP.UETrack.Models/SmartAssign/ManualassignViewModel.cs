using CP.UETrack.Models;
using System;
using System.Collections.Generic;


namespace CP.UETrack.Model.UM
{
   public class ManualassignViewModel
    {

        public int WorkOrderId { get; set; }
        public int MaintenanceType { get; set; }
        public int TypeOfWorkOrder { get; set; }       
        public int WorkOrderStatus { get; set; }
        public string WorkOrderStatusValue { get; set; }
        public string WorkOrderNo { get; set; }
        public string MaintenanceWorkNo { get; set; }
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
        public string Assignee { get; set; }
        public int AssignedUserId { get; set; }
        public int AssigneeLovId { get; set; }
        public string AssingnId { get; set; }
        public DateTime MaintenanceWorkDateTime { get; set; }
        public DateTime TargetDateTime { get; set; }
        public string TypeOfWorkOrderValue { get; set; }
        public string WorkOrderPriorityValue { get; set; }
    }

    public class ManualassignLovs
    {
        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> WarrentyTypeList { get; set; }
        public List<LovValue> StatusList { get; set; }
        public List<LovValue> ReasonList { get; set; }
        public List<LovValue> QCCodeList { get; set; }
        public List<LovValue> CauseCodeList { get; set; }
        public List<LovValue> TransferReasonList { get; set; }
        public List<LovValue> WorkOrderCategoryList { get; set; }
        public List<LovValue> WorkOrderPriorityList { get; set; }

    }

}
