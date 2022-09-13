using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS.CRMWorkOrder
{
    public class CRMWorkorder
    {
        public int CRMRequestWOId { get; set; }
        public string HiddenId { get; set; }
        public string CRMRequestWONo { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public int CRMRequestId { get; set; }
        public string RequestNo { get; set; }
        public int? AssetId { get; set; }
        public string AssetNo { get; set; }
        //public int StaffMasterId { get; set; }
        public int? UserId { get; set; }
        public string StaffName { get; set; }
        public string StaffEmail { get; set; }
        public DateTime CRMWorkOrderDateTime { get; set; }
        public DateTime CRMWorkOrderDateTimeUTC { get; set; }
        public int RequestStatusId { get; set; }
        public string RequestStatus { get; set; }
        public int TypeOfRequestId { get; set; }
        public string TypeOfRequest { get; set; }
        public int WorkOrderStatusId { get; set; }
        public string WorkOrderStatus { get; set; }
        public string Remarks { get; set; }
        public int? ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public int? ModelId { get; set; }
        public string Model { get; set; }
        public string WorkorderDetails { get; set; }
        public string Timestamp { get; set; }
        public int? IsReqTypeReferenced { get; set; }
        public int? IsAssessFinished { get; set; }
        public int? IsCompletionInfoFinished { get; set; }
        public int? TemplateId { get; set; }
        public int? UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int? UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public int NotificationId { get; set; }
        public string MailSts { get; set; }
        public int RequesterId { get; set; }
        public string RequesterName { get; set; }
        public string RequesterEmail { get; set; }
    }
    public class CRMWorkorderDropdownValues
    {
        public List<LovValue> TypeofRequestLov { get; set; }
        public List<LovValue> WorkOrderStatusLov { get; set; }
    }
}
