using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.Framework.Common.SmartAssign.Entity
{
    public class SamrtAssign_Email
    {

        public int WorkOrderId { get; set; }
        public int AssignedUserId { get; set; }
        public string AssigneEmail { get; set; }
        public string MaintenanceWorkNo { get; set; }
        public DateTime? AssignDate { get; set; }
        public int FacilityId { get; set; }
        public string AssigneeName { get; set; }


    }
}
