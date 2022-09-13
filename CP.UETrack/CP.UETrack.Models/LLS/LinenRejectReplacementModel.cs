using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
   public class LinenRejectReplacementModel
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }

        public int LinenRejectReplacementId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime DateTime { get; set; }
        public int CleanLinenIssuesId { get; set; }
        public string CLIDescription { get; set; }
        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public string RejectedBy { get; set; }
        public string ReplacementReceivedBy { get; set; }
        public DateTime ReceivedDateTime { get; set; }
        public decimal TotalQuantityRejected { get; set; }
        public string Remarks { get; set; }
        public string CLINo { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string RejectedByDesignation { get; set; }
        public string ReplacementReceivedByDesignation { get; set; }

        public decimal TotalQuantityReplaced { get; set; }
        public int LinenRejectReplacementDetId { get; set; }
        public int LinenItemId { get; set; }
        public int Ql01aTapeGlue { get; set; }
        public int CleanLinenIssueId { get; set; }
        public int LLSUserAreaId { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        
        public int LLSUserLocationId { get; set; }
        public int Ql01bChemical { get; set; }
        public int Ql01cBlood { get; set; }
        public int Ql01dPermanentStain { get; set; }
        public int Ql02TornPatches { get; set; }
        public int Ql03Button { get; set; }
        public int Ql04String { get; set; }
        public int Ql05Odor { get; set; }
        public int Ql06aFaded { get; set; }
        public int Ql06bThinMaterial { get; set; }
        public int Ql06cWornOut { get; set; }
        public int Ql06d3YrsOld { get; set; }
        public int Ql07Shrink { get; set; }
        public int Ql08Crumple { get; set; }
        public int Ql09Lint { get; set; }
        public int TotalRejectedQuantity { get; set; }
        public int ReplacedQuantity { get; set; }
        public DateTime ReplacedDateTime { get; set; }
       

        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        //==Child2 Table=======
        public List<LLinenRejectGridListItem> LLinenRejectGridList { get; set; }


        //=====================

        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int UserRegistrationId { get; set; }
        public string StaffName { get; set; }
        public string Designation { get; set; }
        

    }
    public class LinenRejectReplacementModel_Filter
    {
        public string Month { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }

        public int LinenRejectReplacementId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime DateTime { get; set; }
        public int CleanLinenIssuesId { get; set; }
        public string CLIDescription { get; set; }
        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public string RejectedBy { get; set; }
        public string ReplacementReceivedBy { get; set; }
        public DateTime ReceivedDateTime { get; set; }
        public decimal TotalQuantityRejected { get; set; }
        public string Remarks { get; set; }
        public string CLINo { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string RejectedByDesignation { get; set; }
        public string ReplacementReceivedByDesignation { get; set; }

        public decimal TotalQuantityReplaced { get; set; }
        public int LinenRejectReplacementDetId { get; set; }
        public int LinenItemId { get; set; }
        public int Ql01aTapeGlue { get; set; }
        public int CleanLinenIssueId { get; set; }
        public int LLSUserAreaId { get; set; }
        public int LLSUserAreaLocationId { get; set; }

        public int LLSUserLocationId { get; set; }
        public int Ql01bChemical { get; set; }
        public int Ql01cBlood { get; set; }
        public int Ql01dPermanentStain { get; set; }
        public int Ql02TornPatches { get; set; }
        public int Ql03Button { get; set; }
        public int Ql04String { get; set; }
        public int Ql05Odor { get; set; }
        public int Ql06aFaded { get; set; }
        public int Ql06bThinMaterial { get; set; }
        public int Ql06cWornOut { get; set; }
        public int Ql06d3YrsOld { get; set; }
        public int Ql07Shrink { get; set; }
        public int Ql08Crumple { get; set; }
        public int Ql09Lint { get; set; }
        public int TotalRejectedQuantity { get; set; }
        public int ReplacedQuantity { get; set; }
        public DateTime ReplacedDateTime { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        //==Child2 Table=======
        public List<LLinenRejectGridListItem_Filter> LLinenRejectGridList { get; set; }


        //=====================

        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int UserRegistrationId { get; set; }
        public string StaffName { get; set; }
        public string Designation { get; set; }


    }
    public class LLinenRejectGridListItem
    {
        public int LinenRejectReplacementDetId { get; set; }
        public int LinenItemId { get; set; }
        public int Ql01aTapeGlue { get; set; }
        public int Ql01bChemical { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int Ql01cBlood { get; set; }
        public int Ql01dPermanentStain { get; set; }
        public int Ql02TornPatches { get; set; }
        public int Ql03Button { get; set; }
        public int Ql04String { get; set; }
        public int Ql05Odor { get; set; }
        public int Ql06aFaded { get; set; }
        public int Ql06bThinMaterial { get; set; }
        public int Ql06cWornOut { get; set; }
        public int Ql06d3YrsOld { get; set; }
        public int Ql07Shrink { get; set; }
        public int Ql08Crumple { get; set; }
        public int Ql09Lint { get; set; }
        public int TotalRejectedQuantity { get; set; }
        public int ReplacedQuantity { get; set; }
        public string Remarks { get; set; }
        public DateTime ReplacedDateTime { get; set; } = DateTime.Now;
        public DateTime EffectiveDate { get; set; }
        public int LinenRejectReplacementId { get; set; }
        

        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class LLinenRejectGridListItem_Filter
    {
        public string Month { get; set; }
        public int LinenRejectReplacementDetId { get; set; }
        public int LinenItemId { get; set; }
        public int Ql01aTapeGlue { get; set; }
        public int Ql01bChemical { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int Ql01cBlood { get; set; }
        public int Ql01dPermanentStain { get; set; }
        public int Ql02TornPatches { get; set; }
        public int Ql03Button { get; set; }
        public int Ql04String { get; set; }
        public int Ql05Odor { get; set; }
        public int Ql06aFaded { get; set; }
        public int Ql06bThinMaterial { get; set; }
        public int Ql06cWornOut { get; set; }
        public int Ql06d3YrsOld { get; set; }
        public int Ql07Shrink { get; set; }
        public int Ql08Crumple { get; set; }
        public int Ql09Lint { get; set; }
        public int TotalRejectedQuantity { get; set; }
        public int ReplacedQuantity { get; set; }
        public string Remarks { get; set; }
        public DateTime ReplacedDateTime { get; set; } = DateTime.Now;
        public DateTime EffectiveDate { get; set; }
        public int LinenRejectReplacementId { get; set; }


        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
}
