using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Home
{
    public class Deduction
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int UserId { get; set; }
        public List<DeductionChart> DeductionChartData { get; set; }
    }
    public class DeductionChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int UserId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public int NameId { get; set; }
        public string Name { get; set; }
        public decimal MSFCost { get; set; }
        public decimal CFCost { get; set; }
        public decimal KPIFCost { get; set; }
        public decimal Cost { get; set; }
        public decimal Percentage { get; set; }
        public string Col { get; set; }
    }
}
