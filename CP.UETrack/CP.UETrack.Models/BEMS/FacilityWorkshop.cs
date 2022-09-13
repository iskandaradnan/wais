using System;
using System.Collections.Generic;
using CP.UETrack.Models;

namespace CP.UETrack.Model.BEMS
{
    public class FacilityWorkshop
    {
        public int FacilityWorkshopId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }

        public int ServiceId { get; set; }
        public string Service { get; set; }
        public string FacilityType { get; set; }
        public int FacilityTypeId { get; set; }
        public string Category { get; set; }
        public int? CategoryId { get; set; }
        public int Year { get; set; }      
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public List<FacilityWorkshopGrid> FacilityWorkshopGridData { get; set; }
    }

    public class FacilityWorkshopGrid
    {
        public int FacilityWorkshopDetId { get; set; }
        public int FacilityWorkshopId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int? AssetId { get; set; }
        public string AssetNo { get; set; }
        public string Description { get; set; }
        public string Manufacturer { get; set; }
        public string SerialNumber { get; set; }
        public string Model { get; set; }
        public string SerialNo { get; set; }
        public DateTime? CalibrationDueDate { get; set; }
        public DateTime? CalibrationDueDateUTC { get; set; }
        public int? LocationId { get; set; }
        public string Location { get; set; }
        public int? Quantity { get; set; }
        public decimal? SizeArea { get; set; }
        public int ListofFacility { get; set; }        
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPages { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsCalibrationDueDateNull { get; set; }
    }
    public class FacilityWorkshopDropdown
    {
        public List<LovValue> ServiceLovs { get; set; }
        public List<LovValue> YearLovs { get; set; }
        public List<LovValue> FacilityTypeLovs { get; set; }
        public List<LovValue> CategoryLovs { get; set; }
        public List<LovValue> LocationLovs { get; set; }
    }
}
