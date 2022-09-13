
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class ReportsAndRecordsList
    {
        public List<ReportRecord> ReportsAndRecords { get; set; }
    }
    public class ReportRecord
    {
        public int CustomerReportId { get; set; }
        public int CustomerId { get; set; }
        public string ReportName { get; set; }
        public bool IsDeleted { get; set; }
    }
}