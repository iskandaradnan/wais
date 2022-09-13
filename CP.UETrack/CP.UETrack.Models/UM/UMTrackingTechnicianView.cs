using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.UM
{
    public class UMTrackingTechnicianView
    {
        public decimal lat { get; set; }
        public decimal lng { get; set; }

        public DateTime? DateTime { get; set; }
    }
}
