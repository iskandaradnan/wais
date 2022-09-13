using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Home
{
    public class KPIChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int UserId { get; set; }
        public List<KPIChartValue> KPIChartValueData { get; set; }
    }
    public class KPIChartValue
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int UserId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public int KPINameId { get; set; }
        public string KPIName { get; set; }
        public decimal KPIPerc { get; set; }
        public decimal Cost { get; set; }
        public string Col { get; set; }
    }
}
