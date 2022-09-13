
using System;

namespace CP.UETrack.Model
{
    public class KPIGenerationDemertis
    {
        public int SerialNo { get; set; }//       
        public DateTime? ServiceWorkDateTime { get; set; }
        public string ServiceRequestNo { get; set; }
        public string ServiceWorkNo { get; set; }//
        public string AssetNo { get; set; }//
        public string AssetDescription { get; set; }//
        public string WorkGroup { get; set; }
        public string AssetTypeCode { get; set; }//
        public string UnderWarranty { get; set; }//
        public string Requestor { get; set; }
        public DateTime? ResponseDateTime { get; set; }//
        public decimal? RepsonseDurationHrs { get; set; }//
        public DateTime? StartDateTime { get; set; }//
        public DateTime? EndDateTime { get; set; }//
        public string WorkOrderStatus { get; set; }//
        public decimal? DowntimeHrs { get; set; }//
        public int DemeritPoint { get; set; }//
        public string SRDetails { get; set; }
        public decimal? PurchaseCostRM { get; set; }
        public int DemeritValue1 { get; set; }
        public decimal? DeductionValue { get; set; }
        public string DocumentNo { get; set; }
        public int FinalDemeritPoint { get; set; }

        public DateTime? TCDate { get; set; }
        public string TCDocumentNo { get; set; }
        public DateTime? RequiredDateTime { get; set; }
        public DateTime? TCCompletedDate { get; set; }
        public string TCStatus { get; set; }
        public string Report { get; set; }
        public string Remarks { get; set; }

        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}
