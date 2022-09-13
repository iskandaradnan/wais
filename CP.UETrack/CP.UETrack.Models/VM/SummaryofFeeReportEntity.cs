using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.VM
{
   public class SummaryofFeeReportEntity
    {
    }
    public class SFRLovEntity
    {
        public List<LovValue> FMTimeMonth { get; set; }
        public List<LovValue> AssetClassificationList { get; set; }
        public List<LovValue> Yearlist { get; set; }
        public List<LovValue> ServiceData { get; set; }
    }

    public class FetchDetails
    {
        public int? Year { get; set; }
        public int? Month { get; set; }
        public int PageSize { get; set; }
        public int PageIndex { get; set; }
        public int ServiceId { get; set; }
        public int? AssetClassificationId { get; set; }
        public int RollOverFeeId { get; set; }
        public List<SummaryEntity> SummaryList { get; set; }
       // public int RollOverFeeId { get; set; }
    }
    public class SFRSaveEntity
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public bool? IsVerified { get; set; }
        public bool? IsApproved { get; set; }
        public int? AssetClassificationId { get; set; }
        public int? ReportId { get; set; }
        public string Flag { get; set; }
        public List<SummaryEntity> SummaryList { get; set; }
        public string ErrorMessage { get; set; }
        public int Status { get; set; }
        public int ServiceId { get; set; }

    }
    public class SummaryEntity
    {
        public string HospitalName { get; set; }
        public decimal? DuringWarrantytotalFee { get; set; }
        public int? DuringWarrantyCount { get; set; }
        public int? PostWarrantyCount { get; set; }
        public decimal? PostWarrantyTotalFee { get; set; }
        public decimal? TotalFeePayable { get; set; }
        public string VerifiedBy { get; set; }
        public string VerifiedDate { get; set; }
        public string ApprovedBy { get; set; }
        public string ApprovedDate { get; set; }
    }
    public class SFRGetallEntity:BaseViewModel
    {
        public int? RollOverFeeId { get; set; }
        public string Service { get; set; }
        public string AssetClassification { get; set; }
        public string Month { get; set; }
        public int? Year { get; set; }
        public string DoneBy { get; set; }
        public string Status { get; set; }
        
    }
}
