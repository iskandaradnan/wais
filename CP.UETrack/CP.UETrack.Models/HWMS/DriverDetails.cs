using CP.UETrack.Models;
using CP.UETrack.Model.FetchModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.Common;

namespace CP.UETrack.Model.HWMS
{
    public class DriverDetails : FetchPagination
    {
       
        public int DriverId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DriverCode { get; set; }
        public string DriverName { get; set; }
        public string TreatmentPlant { get; set; }
        public string Status { get; set; }
        public DateTime EffectiveFrom { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public string ContactNo { get; set; }
        public string Route { get; set; }     
        public List<LicenseDetails> DriverDetailsList { get; set; }
        public List<DriverDetails> AutoDisplay { get; set; }
        public List<DriverDetails> AutoDisplay1 { get; set; }
        public List<LicenseDetails> DDLicenseList { get; set; }
        public List<LicenseDetails> LicenseCodeFetch { get; set; }

        public List<Attachment> AttachmentList { get; set; }

    }
    public class LicenseDetails
    {
        public int LicenseCodeId { set; get; }       
        public string LicenseCode { get; set; }
        public string Description { get; set; }
        public string LicenseNo { get; set; }
        public string ClassGrade { get; set; }
        public string IssuedBy { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool isDeleted { get; set; }
    }
    public class DriverDetailsDropdownList
    {
        public List<LovValue> DriverStatusLovs { get; set; }
        public List<LovValue> ClassGradeLovs { get; set; }
        public List<LovValue> IssuingBodyLovs { get; set; }
        public List<LovValue> TreatmentPlantLovs { get; set; }
        public List<LovValue> RouteLovs { get; set; }

    }
}
