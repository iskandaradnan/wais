using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class EngPlannerRITxn
    {
        public int PlannerId { get; set; }
        public int ServiceId { get; set; }
        public int Year { get; set; }
        public int WorkGroup { get; set; }
        public int WorkOrderType { get; set; }
        public int TypeOfPlanner { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string TotalNoOfAssets { get; set; }
        public int AssigneeId { get; set; }
        public string Assignee { get; set; }
        public int HospitalRepresentativeId { get; set; }
        public string HospitalRepresentative { get; set; }
        public string Month { get; set; }
        public string Week { get; set; }
        public string Day { get; set; }

        public int AssetClarification { get; set; }
        public int WarrentyType { get; set; }     
        public int? AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public int? AssetRegisterId { get; set; }
        public string AssetNo { get; set; }
        public int? StandardTaskDetId { get; set; }
        public string PPMTaskCode { get; set; }
        public string PPMTaskDescription { get; set; }
        public DateTime WarrentyEndDate { get; set; }
        public string WarrantyEndDateString { get; set; }
        public string ContractEndDateString { get; set; }
        public string SupplierName { get; set; }
        public DateTime ContractEndDate { get; set; }
        public string ContractorName { get; set; }
        public string Engineer { get; set; }
        public int EngineerId { get; set; }
        public String ContactNumber { get; set; }

        public String ContactNo { get; set; }
        public int JobTrade { get; set; }
        public int Schedule { get; set; }
        public string Date { get; set; }
        public int Status { get; set; }
        public string Timestamp { get; set; }
        public List<EngPlannerTxn> RIPlannerPopUPDets { get; set; }


    }
   
}
