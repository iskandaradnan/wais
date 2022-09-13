using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model
{
    public class KPITransactionFetchResult
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public int ServiceId { get; set; }
        public int IndicatorDetId { get; set; }

        public int SerialNo { get; set; }
        public int DedTxnMappingId { get; set; }
        public int DedTxnMappingDetId { get; set; }
        public DateTime? ServiceWorkDate { get; set; }
        public string ServiceWorkNo { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string ScreenName { get; set; }
        public int GeneratedDemertiPoints { get; set; }
        public int FinalDemeritPoints { get; set; }
        public int IsValid { get; set; }
        public int DisputedPendingResolution { get; set; }
        public string Remarks { get; set; }
        public int DeductionValue { get; set; }
        public int DedGenerationId { get; set; }
        public bool IsAdjustmentSaved { get; set; }

        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
    public class KPITransactions
    {
        public List<KPITransactionFetchResult> Transactions { get; set; }
        public KPITransactionMapping TranscationMapping { get; set; }
        public int DedTxnMappingId { get; set; }
    }
}
