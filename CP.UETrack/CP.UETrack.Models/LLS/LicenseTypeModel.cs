using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
  public class LicenseTypeModel
    {
        public int LicenseTypeId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string LicenseType { get; set; }
       


        public int LicenseTypeDetId { get; set; }
        public string BatcLicenseTypeCodehNo { get; set; }
        public string LicenseDescription { get; set; }
        public int IssuingBody { get; set; }
        public string  LicenseCode { get; set; }

        public bool IsDeleted { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        //public bool IsDeleted { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }

        public List<LicenseTypeModelList> LicenseTypeModelListData { get; set; }
    }
    public class LicenseTypeModelFilter
    {
        public int LicenseTypeId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string LicenseType { get; set; }



        public int LicenseTypeDetId { get; set; }
        public string BatcLicenseTypeCodehNo { get; set; }
        public string LicenseDescription { get; set; }
        public string IssuingBody { get; set; }
        public string LicenseCode { get; set; }

        public bool IsDeleted { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        //public bool IsDeleted { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }

        public List<LicenseTypeModelList> LicenseTypeModelListData { get; set; }
    }
    public class LicenseTypeModelList
    {
        public int LicenseTypeId { get; set; }
        public int LicenseTypeDetId { get; set; }
        public bool IsDeleted { get; set; }
        public string BatcLicenseTypeCodehNo { get; set; }
        public string LicenseDescription { get; set; }
        public int IssuingBody { get; set; }
        public string LicenseCode { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
    }
    public class LicenseTypeModelLovs
    {
        public List<LovValue> LicenseType { get; set; }
        public List<LovValue> IssuingBody { get; set; }

    }
}
    
