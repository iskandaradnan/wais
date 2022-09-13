using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.Portering
{
    public class LoanerBooking
    {
        public string HiddenId { get; set; }
        public int LoanerTestEquipmentBookingId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int NotificationId { get; set; }
        public string FacilityName { get; set; }
        public int ServiceId { get; set; }
        public int AssetId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string AssetNo { get; set; }
        public int? WorkOrderId { get; set; }
        public string WorkOrderNo { get; set; }
        public DateTime BookingStartFrom { get; set; }
        public DateTime BookingEnd { get; set; }
        public int MovementCategory { get; set; }
        public int ToFacilityId { get; set; }
        public int ToBlockId { get; set; }
        public int ToLevelId { get; set; }
        public int ToUserAreaId { get; set; }
        public int ToUserLocationId { get; set; }
        public int RequestorId { get; set; }
        public string RequestorName { get; set; }
        public string Position { get; set; }
        public int RequestType { get; set; }
        public int BookingStatus { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public string GuId { get; set; }
        public string BlockName { get; set; }
        public string BlockCode { get; set; }
        public string LevelName { get; set; }
        public string LevelCode { get; set; }
        public string UserLocationName { get; set; }
        public string UserLocationCode { get; set; }
        public string UserAreaName { get; set; }
        public string UserAreaCode { get; set; }
        public List<LovValue> ToFacilityLovs { get; set; }
        public List<LovValue> ToBlockLovs { get; set; }
        public List<LovValue> ToLevelLovs { get; set; }
        public List<LovValue> ToUserAreaLovs { get; set; }
        public List<LovValue> ToUserLocationLovs { get; set; }
        public bool IsExtension { get; set; }
        public string Model { get; set; }
        public string Manufacturer { get; set; }
        public string LoanerTestNo { get; set; }

        public string BookingStatusValue { get; set; }
        public bool IsPorteringDone { get; set; }
        public List<AssetBookingDate> AssetBookingDateList { get; set; }

        public List<DateTime> BookedDateList { get; set; }
        public List<string> BookedDateList1 { get; set; }
        public int AssetFacilityId { get; set; }
        public int CompanyRepId { get; set; }
        public string CompanyRepEmail { get; set; }
        public int? LocationInchargeId { get; set; }
        public int? CurrentLoginId { get; set; }
    }


    public class BookingDates
    {
        // public int sno { get; set;  }
        public DateTime BookedDate { get; set; }

    }

    public class AssetBookingDate
    {
        public int LoanerTestEquipmentBookingId { get; set; }
        public DateTime BookingStartFrom { get; set; }
        public DateTime BookingEnd { get; set; }
    }
}
