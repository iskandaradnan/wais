using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS.CRMWorkOrder
{
    public class CRMWorkorderProcessStatus
    {
        public int CRMRequestWOId { get; set; }
        public List<CRMProcessStatus> CRMProcessStatusData { get; set; }
    }

    public class CRMProcessStatus
    {
        public int CRMRequestWOId { get; set; }
        public int CRMProcessStatusId { get; set; }
        public int CRMRequestId { get; set; }
        public int WorkOrderStatusId { get; set; }
        public string WorkOrderStatus { get; set; }
        public string DoneBy { get; set; }
        public string Designation { get; set; }
        public DateTime? Date { get; set; }
        public string StaffName { get; set; }
    }
}
