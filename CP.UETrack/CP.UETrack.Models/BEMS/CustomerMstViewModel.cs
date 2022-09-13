using CP.UETrack.Model;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Models.BEMS
{
    public class CustomerMstViewModel
    {
        public string HiddenId { get; set; }
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; }
        public string Address { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string ContactNo { get; set; }
        public string FaxNo { get; set;  }
        public string Remarks  { get; set; }
        public System.DateTime ActiveFromDate { get; set; }
        public System.DateTime PreviousActiveFromDate { get; set; }
        public System.DateTime ActiveFromDateUTC { get; set; }
        public System.DateTime? ActiveToDate { get; set; }
        public System.DateTime? ActiveToDateUTC { get; set; }
        public string Operation { get; set; }
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }

        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public string Address2 { get; set; }
        public string Postcode { get; set; }
        public string State { get; set; }
        public string Country { get; set; }
        public decimal? ContractPeriodInYears { get; set; }
        public int TypeOfContractLovId { get; set; }
        public int? DocumentId { get; set; }

        public string Base64StringLogo { get; set; }
        public List<MstCustomerContactInfo> ContactInfoList { get; set; }
        public List<LovValue> Services { get; set; }
        public string CustomerType { get; set; }
    }

    public class MstCustomerContactInfo
    {
        public int CustomerContactInfoId { get; set; }
        public int CustomerId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string ContactNo { get; set; }
        public string Email { get; set; }
        public int CreatedBy { get; set; }
      
        public bool Active { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class ActiveFacility
    {
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public int FacilityId { get; set;  }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }
        public DateTime ActiveFromDate { get; set; }
        public DateTime? ActiveToDate { get; set; }
        public string StatusValue { get; set; }
        public bool Status { get; set; }
        public List<ActiveFacility> ActiveFacilityList { get; set; }
    }

}
