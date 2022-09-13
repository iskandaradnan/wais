using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;

namespace CP.UETrack.Model.HWMS
{
    public class TreatmetPlant : FetchPagination
    {
        public int TreatmentPlantId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string TreatmentPlantCode { get; set; }
        public string TreatmentPlantName { get; set; }
        public string RegistrationNo { get; set; }
        public string AdressLine1 { get; set; }
        public string AdressLine2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostCode { get; set; }
        public string Ownership { get; set; }
        public Int64 ContactNumber { get; set; }
        public string FaxNumber { get; set; }
        public string DOEFileNo { get; set; }
        public string OwnerName { get; set; }
        public int NumberOfStore { get; set; }
        public int CapacityOfStorage { get; set; }
        public string Remarks { get; set; }

        public List<TreatmetPlantLicenseDetails> TreatmetPlantLicenseDetails { get; set; }
        public List<TreatmetPlantDisposalType> TreatmetPlantDisposalType { get; set; }
        public List<VehicleDetail> VehicleDetailList { get; set; }
        public List<DriverDetail> DriverDetailList { get; set; }

    }

    public class TreatmetPlantLicenseDetails : FetchPagination
    {
        public int LicenseId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public string LicenseNo { get; set; }
        public string Class { get; set; }
        public DateTime IssueDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool isDeleted { get; set; }
    }

    public class TreatmetPlantDisposalType
    {
        public int DisposalTypeId { get; set; }
        public string MethodofDisposal { get; set; }
        public int Status { get; set; }
        public string DesignCapacity { get; set; }
        public string LicensedCapacity { get; set; }
        public string Unit { get; set; }
        public bool isDeleted { get; set; }
    }
    public class TreatmetPlantDropdown
    {
        public List<LovValue> OwnershipLovs { get; set; }
        public List<LovValue> StateLovs { get; set; }
        public List<LovValue> MethodofDisposalLovs { get; set; }
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> UnitLovs { get; set; }
        
    }
    public class VehicleDetail
    {
        public string VehicleNo { get; set; }
        public string Manufacturer { get; set; }
        public string LoadWeight { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string Status { get; set; }
       
    }
    public class DriverDetail
    {
        public string DriverCode { get; set; }
        public string DriverName { get; set; }
        public string ClassGrade { get; set; }
        public string IssuedBy { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string Status { get; set; }

    }


}
