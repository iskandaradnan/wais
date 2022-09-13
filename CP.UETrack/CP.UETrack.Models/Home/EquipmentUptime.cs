using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Home
{
    public class EquipmentUptime
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int UserId { get; set; }
        public List<EquiUptimeChart> EquiUptimeChartData { get; set; }
    }

    public class EquiUptimeChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public int EquipCatId { get; set; }
        public string EquipCat { get; set; }
        public int Count { get; set; }
        public string Col { get; set; }
    }
}
