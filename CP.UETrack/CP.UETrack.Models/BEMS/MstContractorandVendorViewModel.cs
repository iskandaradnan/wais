using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class MstContractorandVendorViewModel
    {
        public string HiddenId { get; set; }
        public int ContractorId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string ContractorName { get; set; }
        public int ContractorType { get; set; }
        public int ContractorStatus { get; set; }
        public int Status { get; set; }
        public string Address { get; set; }       
        public string City { get; set; }
        public string State { get; set; }
        public string FaxNo { get; set; }
        public string Operation { get; set; }
        public string SSMRegistrationCode { get; set; }
        public List<int> Specialization { get; set; }
        public string SpecializationValues { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
        public string StatusValue { get; set; }
        public bool BuiltIn { get; set; }
        public string GuId { get; set; }
        public string Address2 { get; set; }
        public string Postcode { get; set; }
        public int CountryId { get; set; }
        public string Country { get; set; }
        public int? NoOfUserAccess { get; set; }
        public string ContactNo { get; set; }
        public List<MstContractorandVendorContactInfo> ContactInfoList { get; set; }
    }

    public class MstContractorandVendorContactInfo
    {
        public int ContractorContactInfoId { get; set; }
        public int ContractorId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string ContactNo { get; set; }
        public string Email { get; set; }
        public int CreatedBy { get; set; }
        public bool Active { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class ContractorandVendorLovs
    {
        public List<MultiSelectDD> SpecializationList { get; set; }
        public List<LovValue> StatusList { get; set; }
        public List<LovValue> CountryList { get; set; }

    }


    public class MultiSelectDD
    {
        public int LovId { get; set; }
        public string FieldCode { get; set; }
        public string FieldValue { get; set; }     
        public bool Active { get; set; }
        public bool IsDefault { get; set; }
        public string Remarks { get; set; }
      
    }
}
