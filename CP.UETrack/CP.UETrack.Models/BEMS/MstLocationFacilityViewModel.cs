using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{

    public class FacilityLovs
    {
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; }
        public List<LovValue> TypeofNomenclatureLovs { get; set; }
        public List<LovValue> TypeofContractLovs { get; set; }
        public List<LovValue> WeekDaysLovs { get; set; }
        public List<CustomerLovs> Customers {get;set;}
    }
    public class CustomerLovs
    {
        public int CustomerId { get; set; }
		public string CustomerName { get; set; }
		public string CustomerCode { get; set; }
    }
    public class MstLocationFacilityViewModel
    {
        public string HiddenId { get; set; }
        public int FacilityId { get; set; }
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; }
        public string FacilityName { get; set; }
        public string FacilityCode { get; set; }
        public string Address { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveFromUTC { get; set; }
        public DateTime? ActiveTo { get; set; }
        public DateTime? ActiveToUTC { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }

        public bool BuiltIn { get; set; }
        public string GuId { get; set; }

        public string Address2 { get; set; }
        public string Postcode { get; set; }
        public string State { get; set; }
        public string Country { get; set; }
        public int ContractPeriodInYears { get; set; }
        public int TypeOfContractLovId { get; set; }
        public int? DocumentId { get; set; }
        public decimal? MonthlyServiceFee { get; set; }
        public List<MstLocationFacilityContactInfo> ContactInfoList { get; set; }
        public string WeeklyHolidayValues { get; set; }
        public List<int> WeeklyHolidays { get; set; }
        public int? TypeOfNomenclature { get; set; }
        public int? LifeExpectancy { get; set; }
        public string Base64StringLogo { get; set; }
        public string ContactNo { get; set; }
        public string FaxNo { get; set; }
        public int? WarrantyRenewalNoticeDays { get; set; }
        public decimal? InitialProjectCost { get; set; }
        public int? IsContractPeriodChanged { get; set; }

        public bool canShowVariationButton { get; set; }
        public int varationAssetCount { get; set; }

        //-----------Added for Services
        public int BEMS { get; set; }
        public int FEMS { get; set; }
        public int CLS { get; set; }
        public int LLS { get; set; }
        public int HWMS { get; set; }

    }

    public class FacilityVariation
    {
        public int varationAssetCount { get; set; }
        public int FacilityId { get; set; }
        public decimal? MonthlyServiceFee { get; set; }
        public string Timestamp { get; set; }
    }
        public class MstLocationFacilityContactInfo
    {
        public int FacilityContactInfoId { get; set; }
        public int FacilityId { get; set; }
        public int CustomerId { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string ContactNo { get; set; }
        public string Email { get; set; }
        public int CreatedBy { get; set; }
        public bool Active { get; set; }
        public bool IsDeleted { get; set; }

    }
}
