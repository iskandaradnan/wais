using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS.CRMWorkOrder
{
    public class CRMWorkorderCompInfo
    {
        public int CRMCompletionInfoId { get; set; }
        public int CRMRequestWOId { get; set; }
        public string CRMRequestWONo { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public int CRMRequestId { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime StartDateTimeUTC { get; set; }
        public DateTime EndDateTime { get; set; }
        public DateTime EndDateTimeUTC { get; set; }
        public DateTime HandOverDateTime { get; set; }
        public DateTime HandOverDateTimeUTC { get; set; }
        public int? AcceptedById { get; set; }
        public string AcceptedBy { get; set; }
        public string Signature { get; set; }
        public string Remarks { get; set; }
        public string Timestamp { get; set; }
        public int? CompletedById { get; set; }
        public string CompletedBy { get; set; }
        public int CompbyPositionId { get; set; }
        public string CompbyPosition { get; set; }
        public string CompletedRemarks { get; set; }
        public int TypeOfRequestId { get; set; }
        public int WorkOrderStatusId { get; set; }
        public string WorkOrderStatus { get; set; }
        public int NotificationId { get; set; }
        public int UserId { get; set; }
        public string AssigneeEmail { get; set; }
        public int RequesterId { get; set; }
        public string RequesterName { get; set; }
        public string RequesterEmail { get; set; }
        public int? TemplateId { get; set; }
        public string HiddenId { get; set; }
    }
}
