using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using CP.UETrack.Model.Common;

namespace CP.UETrack.Model.HWMS
{
    public class VehicleDetails : FetchPagination
    {
        public int VehicleId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }

        public string VehicleNo { get; set; }
        public string Manufacturer { get; set; }
        public string TreatmentPlant { get; set; }
        public string Status { get; set; }
        public DateTime EffectiveFrom { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public int LoadWeight { get; set; }
        public string Route { get; set; }
        
        public List<LicenseVehicleDetails> VehicleDetailsList { get; set; }
        public List<VehicleDetails> AutoDisplay { get; set; }
        public List<VehicleDetails> AutoDisplay1 { get; set; }

        public List<LicenseVehicleDetails> DDLicenseList { get; set; }
        public List<LicenseVehicleDetails> LicenseCodeFetch { get; set; }

        public List<Attachment> AttachmentList { get; set; }
    }
    public class LicenseVehicleDetails
    {      
        public int LicenseCodeId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public string LicenseNo { get; set; }
        public string ClassGrade { get; set; }
        public string IssuedBy { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool isDeleted { get; set; }

    }
    public class VehicleDetailsDropdown
    {
        public List<LovValue> VehicleStatusLovs { get; set; }
        public List<LovValue> ClassGradeLovs { get; set; }
        public List<LovValue> VehicleManufacturerLovs { get; set; }
        public List<LovValue> IssuingBodyLovs { get; set; }
        public List<LovValue> TreatmentPlantLovs { get; set; }
        public List<LovValue> RouteLovs { get; set; }


    }
}
