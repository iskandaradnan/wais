using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class CRMRequestEntity
    {
        public DateTime Responce_Date { get; set; }
        public DateTime Completed_Date { get; set; }
        public int Completed_By { get; set; }
        public int CRMRequestId { get; set; }
        public string HiddenId { get; set; }
        public string Completed_By_Name { get; set; }
        public string HiddenIdReq { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceKey1 { get; set; }
        public string ServiceKey { get; set; }
        public string RequestNo { get; set; }
        public string Designation { get; set; }
        public string MobileNumber { get; set; }

        public DateTime RequestDateTime { get; set; }
        public DateTimeOffset RequestDateTimeUTC { get; set; }

        public DateTimeOffset WorkorderTimeUTC { get; set; }
        public int RequestStatus { get; set; }
        public string RequestStatusValue { get; set; }
        public string RequestDescription { get; set; }
        public int TypeOfRequest { get; set; }
        public string TypeOfRequestVal { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsWorkorderGen { get; set; }
        public int? IsReqTypeReferenced { get; set; }
        public int? ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public int? ModelId { get; set; }
        public string Model { get; set; }
        public int? UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int? UserAreaCompRepId { get; set; }
        public int? UserAreaFacRepId { get; set; }
        public string UserAreaCompRep { get; set; }
        public string UserAreaFacRep { get; set; }
        public int? UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public int? BlockId { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public int? LevelId { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }

        public int CRMWorkorderId { get; set; }
        public string CRMWorkorderNo { get; set; }
        public DateTime? WorkorderDate { get; set; }
        public int NotificationId { get; set; }
        public string FMREQProcess { get; set; }
        
        public int? ReqStaffId { get; set; }
        public string ReqStaff { get; set; }

        public string WorkOrderStatus { get; set; }
        public string AccessFlag { get; set; }

        public DateTime? TargetDate { get; set; }
        public string ISTargetDateOver { get; set; }
        public int? RequestPersonId { get; set; }
        public string RequestPerson { get; set; }
        public int? AssigneeId { get; set; }
        public string Assignee { get; set; }
        public string AssigneeEmail { get; set; }
        public string RequesterEmail { get; set; }
        public string ChkStsApproveorNot { get; set; }
        public string ChkEntUser { get; set; }
        public int? WOAssigneeId { get; set; }
        public string WOAssignee { get; set; }
        public string WOAssigneeEmail { get; set; }
        public int? TemplateId { get; set; }
        public DateTime CurrentDatetimeLocal { get; set; }
        public List<CRMRequestGrid> CRMRequestGridData { get; set; }
        public List<CRMRequestRemHisGrid> CRMRequestRemHisGridData { get; set; }

        public int TypeOfServiceRequest { get; set; }
        public int PriorityList { get; set; }
        public string CRMRequest_PriorityStatus { get; set; }
        public string NCRDescription { get; set; }
        // public int Indicators_all { get; set; }

        public int TypeOfDeduction { get; set; }

        public string LLSAssessment { get; set; }
        public int LLSResponse_by_ID { get; set; }
        public string LLSResponse_by { get; set; }

        public string LLSAction_Taken { get; set; }
        public string LLSJustification { get; set; }
        public int LLSValidation { get; set; }
        public List<Indicator> Indicators { get; set; }
        public string Indicators_all { get; set; }
        public int Indicator_ID { get; set; }
        public int Indicator_ID_P { get; set; }
        public string Indicator_Code { get; set; }
        public string Indicator_Name { get; set; }
        public string Action_Taken { get; set; }

        public string NcrRemarks { get; set; }
        public string AssetNo { get; set; }

        public int AssetId { get; set; }

        public int? WorkGroup { get; set; }
        public int? WasteCategory { get; set; }

        public DateTime RequestedDate { get; set; }

    }
    public class Indicator
    {
        public int Indicator_ID { get; set; }
        public int Indicator_ID_P { get; set; }
        public string Indicator_Code { get; set; }
        public string Indicator_Name { get; set; }
        public int LovId { get; set; }
        public string FieldValue { get; set; }
    }
    public class CORMDropdownList
    {
        public List<LovValue> RequestTypeList { get; set; }
        public List<LovValue> RequestStatusList { get; set; }

        public List<LovValue> RequestServiceList { get; set; }
        public List<LovValue> IndicatorList { get; set; }
        public List<LovValueDesc> IndicatorList_Descr { get; set; }

        public List<Indicator> Indicators { get; set; }
        public List<LovValueDesc> PriorityList { get; set; }
        public List<LovValue> WorkGroup { get; set; }
        public List<LovValue> WasteCategory { get; set; }
        public List<LovValue> CRMJUstification { get; set; }

    }
    public class getallEntity
    {
        public int CRMRequestId { get; set; }
        public string RequestNo { get; set; }
        public DateTime RequestDateTime { get; set; }
        public string TypeOfRequest { get; set; }
        public string RequestStatus { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public int TotalRecords { get; set; }

    }

    public class CRMRequestGrid
    {
        public int CRMRequestDetId { get; set; }
        public int CRMRequestId { get; set; }
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string SerialNo { get; set; }
        public string SoftwareVersion { get; set; }
        public string SoftwareKey { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPages { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }

        public int NotificationId { get; set; }
        public string RequestNo { get; set; }

    }

    public class CRMRequestRemHisGrid
    {
        public int CRMRequestHistId { get; set; }
        public int CRMRequestId { get; set; }
        public int SNo { get; set; }
        public string Remarks { get; set; }
        public string DoneBy { get; set; }
        public DateTime? Date { get; set; }
        public string Status { get; set; }
        public int StatusId { get; set; }

    }
}
