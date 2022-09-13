using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
   public class LicenseAndCertificateEntity : BaseViewModel
    {
        public string HiddenId { get; set; }
        public int LicenseId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
       
        public string LicenseNo { get; set; }
        public string LicenseDescription { get; set; }
        public string StatusVal { get; set; }
        public int? Status { get; set; }
        public string CategoryVal { get; set; }
        public int? Category { get; set; }
        public string IfOthersSpecify { get; set; }
        public int? Type { get; set; }
        public string ClassGrade { get; set; }
        public int? ContactPersonStaffId { get; set; }
        public int IssuingBody { get; set; }
        public string IssuingBodyVal { get; set; }
        public DateTime IssuingDate { get; set; }
        public DateTime IssuingDateUTC { get; set; }
        public DateTime? NotificationForInspection { get; set; }
        public DateTime? NotificationForInspectionUTC { get; set; }
        public DateTime? InspectionConductedOn { get; set; }
        public DateTime? InspectionConductedOnUTC { get; set; }
        public DateTime? NextInspectionDate { get; set; }
        public DateTime? NextInspectionDateUTC { get; set; }
        public DateTime? ExpireDate { get; set; }
        public DateTime? ExpireDateUTC { get; set; }
        public DateTime? PreviousExpiryDate { get; set; }
        public DateTime? PreviousExpiryDateUTC { get; set; }
        public string RegistrationNo { get; set; }
        public string ErrorMsg { get; set; }
        public string ContactPerson { get; set; }
        public string AssetNo { get; set; }
        public DateTime? ExpiryDate { get; set; }
        public string AssetDescription { get; set; }
        public string AssetTypeCode { get; set; }
        public int? AssetTypeCodeId { get; set; }
        public string AssetTypeDescription { get; set; }
        public string LicenseNohistory { get; set; }

        public List<EngLicenseandCertificateTxnDet> EngLicenseandCertificateTxnDetList { get; set; }

        public List<EngLicenseandCertificateTxnHistory> EngLicenseandCertificateTxnHistoryList { get; set; }

    }

    public class EngLicenseandCertificateTxnHistory
    {
        public string LicenseNo { get; set; }
        public DateTime? ExpireDate { get; set; }
        public DateTime IssuingDate { get; set; }
    }

        public class EngLicenseandCertificateTxnDet
    {
        public int LicenseDetId { get; set; }
        public int LicenseId { get; set; }
        public int? AssetId { get; set; }
        public int? StaffId { get; set; }
        public string StaffName { get; set; }
        public string AssetTypeCode { get; set; }
        public string Designation { get; set; }
        public string Remarks { get; set; }
        //public int IssuingBody { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string EmpId { get; set; }
        public string EmployeeName { get; set; }
        public bool IsDeleted { get; set; }
        public int PageIndex { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPages { get; set; }

    }
    public class GetallEntity
    {
        public int LicenseId { get; set; }
        public string LicenseNo { get; set; }
        public string StatusVal { get; set; }
        public string CategoryVal { get; set; }
        public DateTime? ExpiryDate { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string IssuingBodyVal { get; set; }
        public string ClassGrade { get; set; }
    }
    public class LCDropdownentity
    {

        public List<LovValue> LCCategoryValueList { get; set; }
        public List<LovValue> LCPersonnelTypeValueList { get; set; }
        public List<LovValue> LCAssetTypeValueList { get; set; }
        public List<LovValue> StatusValueList { get; set; }
        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> OperatingDaysList { get; set; }
        public List<LovValue> IssuingBodyList { get; set; }
        public List<LovValue> Designations { get; set; }
    }
}
