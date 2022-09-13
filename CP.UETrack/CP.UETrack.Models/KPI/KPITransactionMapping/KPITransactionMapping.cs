
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class KPITransactionMapping
    {
        public int DedTxnMappingId { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public string MonthName { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int DedGenerationId { get; set; }
        public int IndicatorDetId { get; set; }
        public int UserId { get; set; }
        public string IndicatorNo { get; set; }
        public string Timestamp { get; set; }
    }
}