using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.Framework.Common.SmartAssign.Entity
{
    public class SmartAssign_GetPending
    {
        public int WorkOrderId { get; set; }
        public int FacilityId { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string MaintenanceWorkNo { get; set; }

    }
}
