using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.Portering
{
    public class PorteringModel
    {
        public string HiddenId { get; set; }
        public int PorteringId { get; set; }
        public int FromCustomerId { get; set; }
        public string MovementCategoryValue { get; set; }
        public int FromFacilityId { get; set; }
        public int FromBlockId { get; set; }
        public int CustomerId { get; set; }
        public int FromLevelId { get; set; }
        public int FromUserAreaId { get; set; }
        public int FromUserLocationId { get; set; }
        public int? MovementCategory { get; set; }
        public int RequestorId { get; set; }
        public string ContactNo { get; set; }
        public int RequestTypeLovId { get; set; }
        public int NotificationId { get; set; }
        public int? SubCategory { get; set; }
        public int? ModeOfTransport { get; set; }
        public int? ToCustomerId { get; set; }
        public int? ToFacilityId { get; set; }
        public int? ToBlockId { get; set; }
        public int? ToLevelId { get; set; }
        public int? ToUserAreaId { get; set; }
        public int? ToUserLocationId { get; set; }
        public int? AssignPorterId { get; set; }
        public string ConsignmentNo { get; set; }
        public int? PorteringStatus { get; set; }
        public string PorteringStatusValue { get; set; }
        public int? ReceivedBy { get; set; }
        public string ReceivedByPosition { get; set; }
        public int? CurrentWorkFlowId { get; set; }
        public string Remarks { get; set; }
        public string Timestamp { get; set; }
        public int? AssetId { get; set; }
        public string AssetNo { get; set; }
        public string WorkOrderNo { get; set; }
        public string RequestorName { get; set; }
        public string Position { get; set; }
        public DateTime? PorteringDate { get; set; }
        public string PorteringNo { get; set; }
        public int? WorkOrderId { get; set; }
        public string CourierName { get; set; }
        public DateTime? ConsignmentDate { get; set; }
        public DateTime? WFStatusApprovedDate { get; set; }
        public List<LovValue> ToFacilityLovs { get; set; }
        public List<LovValue> ToBlockLovs { get; set; }
        public List<LovValue> ToLevelLovs { get; set; }
        public List<LovValue> ToUserAreaLovs { get; set; }
        public List<LovValue> ToUserLocationLovs { get; set; }
        public int? SupplierLovId { get; set; }
        public int? SupplierId { get; set; }
        public int? LoanerTestEquipmentBookingId { get; set; }
        public string ScanAsset { get; set; }
        public string FacilityName { get; set; }
        public string BlockName { get; set; }
        public string LevelName { get; set; }
        public string UserLocationName { get; set; }
        public string UserAreaName { get; set; }
        public string AssignPorterName { get; set; }
        public List<LovValue> WarrantyCategoryLovs { get; set; }
        public List<AssetTrackerLov> VendorNameLovs { get; set; }
        public List<PorteringHistoryDet> PorteringHistoryDets { get; set; }
        public string ReceivedByName { get; set; }
        public string WorkFlowStatus { get; set; }
        public string Assignee { get; set; }

        /*Added for smart assign*/
        public int? MAPAssigneId { get; set; }
        public string MAPAssigneName { get; set; }
        public string AssigneeType { get; set; }
        public int? EngineerId { get; set; }
        public string EngEmail { get; set; }
        public int? LocationInchargeId { get; set; }
        public string LocationInchargeName { get; set; }       
        public string BlockCode { get; set; }      
        public string LevelCode { get; set; }      
        public string UserLocationCode { get; set; }     
        public string UserAreaCode { get; set; }

        public string ToBlockCode { get; set; }
        public string ToLevelCode { get; set; }
        public string ToUserLocationCode { get; set; }
        public string ToUserAreaCode { get; set; }

        public string ToBlockName { get; set; }
        public string ToLevelName { get; set; }
        public string ToUserLocationName { get; set; }
        public string ToUserAreaName { get; set; }

    }
    public class PorteringTransactionWorkFlow
    {
        public int PorteringId { get; set; }
        public int PorteringDetId { get; set; }
        public int WorkFlowId { get; set; }
        public string Remarks { get; set; }
    }


    public class PorteringLocation
    {
        public string Email { get; set; }
        public string AssetNo { get; set; }
        public string AssetId { get; set; }
        public string PorteringId { get; set; }
        public DateTime PorteringDate { get; set; }
        public string PorteringNo { get; set; }
        public string RequestorName { get; set; }
        public DateTime? WFStatusApprovedDate { get; set; }
        public string RequestorEmail { get; set; }

    }


    public class PorteringHistoryDet
    {

        public string WorkFlowStatusIdValue { get; set; }
        public int? WFDoneBy { get; set; }
        public string WFDoneByValue { get; set; }
        public DateTime? WFDoneByDate { get; set; }
        public DateTime? LastUpdatedDate { get; set; }
        public string PorteringStatusLovIdValue { get; set; }
        public int? PorteringStatusLovId { get; set; }
        public int? PorteringStatusDoneBy { get; set; }
        public string PorteringStatusDoneByValue { get; set; }
        public bool IsMoment { get; set; }
        public string Remarks { get; set; }
        public DateTime? PorterigDonebyDate { get; set; }
    }


    public class SmartAssignPorteringAssignment
    {
        public int PorteringId { get; set; }
        public int PorteringAssignmentId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int AssetId { get; set; }
        public int AssignedStaffId { get; set; }

    }
    public class AssetTrackerLov
    {
        public int LovId { get; set; }
        public string FieldValue { get; set; }
        public bool DefaultValue { get; set; }
        public string Email { get; set; }
    }
    public class PorteringLovs
    {
        public int ToFacilityId { get; set; }
        public int ToBlockId { get; set; }
        public int ToLevelId { get; set; }
        public int ToUserAreaId { get; set; }
        public int LocationNo { get; set; }
        public DateTime PorteringDate { get; set; }
        public List<LovValue> FromFacilityLovs { get; set; }
        public List<LovValue> FromBlockLovs { get; set; }
        public List<LovValue> FromLevelLovs { get; set; }
        public List<LovValue> FromUserAreaLovs { get; set; }
        public List<LovValue> FromUserLocationLovs { get; set; }
        public List<LovValue> MovementCategoryLovs { get; set; }
        public List<LovValue> ToFacilityLovs { get; set; }
        public List<LovValue> ToBlockLovs { get; set; }
        public List<LovValue> ToLevelLovs { get; set; }
        public List<LovValue> ToUserAreaLovs { get; set; }
        public List<LovValue> ToUserLocationLovs { get; set; }
        public List<LovValue> RequestTypeLovs { get; set; }
        public List<LovValue> ModeOfTransportLovs { get; set; }
        public List<LovValue> WorkFlowStatusLovs { get; set; }
        public List<LovValue> PorteringStatusLovs { get; set; }
        public List<LovValue> CascadeLocationLovs { get; set; }
        public List<LovValue> WarrantyCategoryLovs { get; set; }
        public List<AssetTrackerLov> VendorNameLovs { get; set; }
        public DateTime CurrentDate { get; set; }
        public int FacilityId { get; set; }
    }


    public class AssetBooking
    {
        public int BookingId { get; set; }
        public int AssetId { get; set; }
        public DateTime BookingStartFrom { get; set; }
        public DateTime BookingEndDate { get; set; }
    }
}












