using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Home
{
    public class BERAsset
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int UserId { get; set; }
        public List<BERAssetChart> BERAssetChartData { get; set; }
    }

    public class BERAssetChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int UserId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public int Count { get; set; }
        public int BER2Count { get; set; }
        public string Col { get; set; }
        public decimal Percentage { get; set; }
        public decimal BER2Percentage { get; set; }
    }
}
