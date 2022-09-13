
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class ReportsAndRecordsLst
    {
        public List<ReportsAndRecords> ReportsAndRecords { get; set; }
        public int ReportsandRecordTxnId { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public string ReportName { get; set; }
        public bool Submitted { get; set; }
        public bool Verified { get; set; }
        public string MonthName { get; set; }
        public string YearName { get; set; }
        public string StatusName { get; set; }

    }
    public class ReportsAndRecords
    {
        public int ReportsandRecordTxnDetId { get; set; }
        public int ReportsandRecordTxnId { get; set; }
        public int? CustomerReportId { get; set; }
        public string ReportName { get; set; }
        public bool Submitted { get; set; }
        public bool Verified { get; set; }
        public bool? RecordSubmitted { get; set; }
        public bool? RecordVerified { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public bool IsDeleted { get; set; }
    }
}