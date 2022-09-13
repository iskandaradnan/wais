using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class CRMWorkorderAssign
    {
        public int CRMRequestWOId { get; set; }
        public string CRMRequestWONo { get; set; }
        public int? StaffId { get; set; }
        public string StaffName { get; set; }        
        public int TypeOfRequestId { get; set; }
        public string TypeOfRequest { get; set; }       
        public string Remarks { get; set; }
        public DateTime? CRMWorkOrderDateTime { get; set; }
        public List<CRMWorkorderAssignGrid> CRMWorkorderAssignGridData { get; set; }
    }

    public class CRMWorkorderAssignGrid
    {
        public int CRMRequestWOId { get; set; }
        public string CRMRequestWONo { get; set; }
        public int? StaffId { get; set; }
        public string StaffName { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int CRMRequestId { get; set; }
        public string RequestNo { get; set; }
        public DateTime? CRMWorkOrderDateTime { get; set; }
        public DateTime? CRMWorkOrderDateTimeUTC { get; set; }
        public bool IsDeleted { get; set; }
        public int TypeOfRequestId { get; set; }
        public string TypeOfRequest { get; set; }
    }

}
