using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS.CRMWorkOrder
{
    public class CRMWorkorderAssessment
    {
        public int CRMAssesmentId { get; set; }
        public int CRMRequestWOId { get; set; }
        public string CRMRequestWONo { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }        
        public int StaffMasterId { get; set; }
        public string StaffName { get; set; }
        public string Feedback { get; set; }
        public DateTime AssessmentStartDate { get; set; }
        public DateTime AssessmentStartDateUTC { get; set; }
        public DateTime AssessmentEndDate { get; set; }
        public DateTime AssessmentEndDateUTC { get; set; }      
        public string Timestamp { get; set; }
        public int TypeOfRequestId { get; set; }
        public int WorkOrderStatusId { get; set; }
        public string WorkOrderStatus { get; set; }
        public int RequesterId { get; set; }
        public string RequesterName { get; set; }
        public string RequesterEmail { get; set; }
        public int NotificationId { get; set; }
        public string HiddenId { get; set; }
    }
}
