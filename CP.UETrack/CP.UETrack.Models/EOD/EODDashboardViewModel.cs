using System;
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class EODDashboardViewModel
    {
        public int CategorySystemId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public string CategorySystemName { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; }
        public bool BuiltIn { get; set; }
        public List<LovValue> ServiceData { get; set; }
        public List<DashboardGrid> DashboardGridData { get; set; }

    }

    public class DashboardGrid
    {
        public int CategorySystemId { get; set; }
        public int ServiceId { get; set; }
        public string CategorySystemName { get; set; }
        public int Pass { get; set; }
        public int Fail { get; set; }
        public int Total { get; set; }
        public decimal PassPerc { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public string MonthName { get; set; }
        public int NoofMonths { get; set; }

    }
}
