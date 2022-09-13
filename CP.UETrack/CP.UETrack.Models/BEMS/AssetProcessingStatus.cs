using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
   public class AssetProcessingStatus
    {
        public string DocumentNo { get; set; }
        public string ProcessName { get; set; }
        public Nullable<DateTime> DoneDate { get; set; }
        public string ProcessStatus { get; set; }
        public int AssetId { get; set; }

    }
}
