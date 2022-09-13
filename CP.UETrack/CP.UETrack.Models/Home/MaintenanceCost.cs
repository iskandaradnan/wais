using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Home
{
    public class MaintenanceCost
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int UserId { get; set; }
        public List<MaintCostChart> MaintCostChartData { get; set; }
    }

    public class MaintCostChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public string MaintenCat { get; set; }
        public decimal Cost { get; set; }
        public string Col { get; set; }
    }
}
