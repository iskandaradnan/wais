using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
   public class ContractOutRegisterEntity
    {
        public string AssetNo { get; set; }
        public string HiddenId { get; set; }
        public int ContractId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string ContractorName { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public string HospitalCode { get; set; }
        public string ContractNo { get; set; }
        public string ContractorCode { get; set; }
        public string contractCode { get; set; }
        public int ContractorId { get; set; }
        public DateTime startDate { get; set; }
        public DateTime? endDate { get; set; }
        public int ContractorType { get; set; }
        public string ContactPerson { get; set; }
        public string SecResponsiblePerson { get; set; }
        public string Designation { get; set; }
        public string SecDesignation { get; set; }
        public string ContactNo { get; set; }
        public string SecTelephoneNo { get; set; }
        public string FaxNo { get; set; }
        public string SecFaxNo { get; set; }
        public string Email { get; set; }
        public decimal ContractSum { get; set; }
        public string ContractSumString { get; set; }
        public string scopeOfWork { get; set; }
        public string remarks { get; set; }
        public int Status { get; set; }
        public string StatusVal { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public DateTime? NotificationForInspection { get; set; }
        public string Timestamp { get; set; }
        public List<AssetList> AssetList { get; set; }
        public List<HistoryTab> HistoryTab { get; set; }
        public bool IsRenewed { get; set; }
        public bool AllowRenew { get; set; }
    }


    public class HistoryTab
    {
        public int ContractHistoryId { get; set; }
        public DateTime ContractEndDate { get; set; }
        public DateTime ContractStartDate { get; set; }
        public int ContractId { get; set; }
         public string ContractNo { get; set; }
        public string AssetNo { get; set; }
        public int AssetId { get; set; }
        public string AssetDescription { get; set; }
        public string ContractTypeName { get; set; }
        public int ContractType { get; set; }
        public decimal ContractValue { get; set; }
        public string ContractValueString { get; set; }
    }
    public class CORDropdownList
    {
        public List<LovValue> ContractTypeValueList { get; set; }
        public List<LovValue> StatusValueList { get; set; }
       // public List<LovValue> ContractTypeValueList { get; set; }

    }
    public class AssetList
    {
        public int ContractDetId { get; set; }
        public int ContractId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string AssetNo { get; set; }
        public int AssetId { get; set; }
        public string AssetDescription { get; set; }
        public string ContractTypeName { get; set; }
        public int ContractType { get; set; }
        public Decimal ContractValue { get; set; }
        public string ContractValueString { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }

        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public bool IsDeleted { get; set; }
        public int ContractHistoryId { get; set; }
    }
    public class CORGetallEntity
    {

        public int ContractId { get; set; }
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string ContractorCode { get; set; }
        public string ContractorName { get; set; }
        public string ContactNo { get; set; }
        public string AssetNo { get; set; }
        public string ContractNo { get; set; }
        public DateTime ContractStartDate { get; set; }
        public DateTime ContractEndDate { get; set; }
        public string Status { get; set; }
        public string StatusVal { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
    }
}
