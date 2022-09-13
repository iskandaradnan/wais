using CP.UETrack.Model.Common;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System.Collections.Generic;


namespace CP.UETrack.Model.HWMS
{
    public class LicenseType : FetchPagination
    {
        public int LicenseTypeId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string LicenseOfType { get; set; }
        public string WasteCategory { get; set; }
        public string WasteType { get; set; }          
        public List<LicCodeDes> licenseCodeList { get; set; }
        public List<Attachment> AttachmentList { get; set; }
    }
    public class LicCodeDes : FetchPagination
    {
        public int LicenseId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public string IssuingBody { get; set; }
        public bool isDeleted { get; set; }
    }
    public class LicenseTypeeDropdown
    {
        public List<LovValue> LicenseTypeeLovs { get; set; }
        public List<LovValue> IssuingBodyLovs { get; set; }
        public List<LovValue> WasteTypeLovs { get; set; }
        public List<LovValue> WasteCategoryLovs { get; set; }
    }
}