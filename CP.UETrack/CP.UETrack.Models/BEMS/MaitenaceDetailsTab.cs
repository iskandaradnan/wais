using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
  public  class MaitenaceDetailsTab
    {
        public string MaintenanceWorkNo { get; set; }
        public Nullable <DateTime> WorkOrderDate { get; set; }
        public string WorkCategory { get; set; }
        public string Type { get; set; }
        public decimal? TotalDowntime { get; set; }
        public decimal? TotalCost { get; set; }
        public int AssetId { get; set; }
    }
}
