using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
   public class WarrantyManagement
    {
        public int WarrantyMgmtId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public string WarrantyNo { get; set; }
        public DateTime? WarrantyDate { get; set; }
        public DateTime? WarrantyDateUtc { get; set; }
        public string TnCRefNo { get; set; }
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetClassification { get; set; }
        public string TypeCode { get; set; }
        public string AssetDescription { get; set; }
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public int WarrantyPeriod { get; set; }
        public double PurchaseCost { get; set; }
        public double DWFee { get; set; }
        public double PWFee { get; set; }
        public double WarrantyDownTime { get; set; }
        public string Remarks { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool IsWarrantyDateNull { get; set; }
        public bool IsWarrStartDateNull { get; set; }
        public bool IsWarrEndDateNull { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaName { get; set; }

        public List<WMWOrkOrderGrid> WMWorkorderGriddata { get; set; }
        public List<WMDefectDetailsGrid> WMDefectDetailsGriddata { get; set; }
    }

    public class ServiceLov
    {
        public List<LovValue> ServiceLovs { get; set; }
    }

    //public class WMDefectDetails
    //{
    //    public int WarrantyMgmtId { get; set; }
    //    public string WarrantyNo { get; set; }
    //    public DateTime WarrantyDate { get; set; }
    //    public DateTime WarrantyDateUtc { get; set; }
    //    public int AssetId { get; set; }
    //    public string AssetNo { get; set; }
    //    public List<WMDefectDetailsGrid> WMDefectDetailsGriddata { get; set; }
    //}

    public class WMDefectDetailsGrid
    {
        public DateTime DefectDate { get; set; }
        public string DefectDetails { get; set; }
        public DateTime StartDate { get; set; }
        public bool IsCompleted { get; set; }
        public DateTime CompletionDate { get; set; }
        public string ActionTaken { get; set; }
        public int WarrantyMgmtetId { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPages { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public bool IsDefectDateNull { get; set; }
        public bool IsStartDateNull { get; set; }
        public bool IsCompletionDateNull { get; set; }
    }

    //public class WMWOrkOrder
    //{
    //    public int WarrantyMgmtId { get; set; }
    //    public string WarrantyNo { get; set; }
    //    public DateTime WarrantyDate { get; set; }
    //    public DateTime WarrantyDateUtc { get; set; }
    //    public int AssetId { get; set; }
    //    public string AssetNo { get; set; }
    //    public string AssetDesc { get; set; }
    //    public List<WMWOrkOrderGrid> WMWorkorderGriddata { get; set; }
    //}
    public class WMWOrkOrderGrid
    {
        public int WarrantyMgmtetId { get; set; }
        public int WorkorderId { get; set; }
        public string WorkorderNo { get; set; }
        public string WorkorderType { get; set; }
        public DateTime? ResponseDate { get; set; }
        public DateTime? TargetDate { get; set; }
        public DateTime? CompletionDate { get; set; }
        public string WorkorderStatus { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPages { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public bool IsResposeDateNull { get; set; }
        public bool IsTargetDateNull { get; set; }
        public bool IsCompDateNull { get; set; }
    }
}

