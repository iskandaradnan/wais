using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
   public class DriverDetailsModel
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string HiddenId { get; set; }
        public int DriverId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DriverCode { get; set; }
        public string LaundryPlantName { get; set; }
        public int LaundryPlantId { get; set; }
        public string DriverName { get; set; }
        public int Status { get; set; }
        public string Statuss { get; set; }
        public string ICNo { get; set; }
        public DateTime EffectiveFrom { get; set; } = DateTime.Now;
        public DateTime EffectiveTo { get; set; } = DateTime.Now;
        public string ContactNo { get; set; }


        public int DriverDetId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public int LicenseTypeDetId { get; set; }
        public string LicenseNo { get; set; }
        public string ClassGrade { get; set; }
        public string IssuedBy { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }

        //==Child2 Table=======
        public List<LDriverDetailsLinenItemList> LDriverDetailsLinenItemGridList { get; set; }


        //=====================

        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class DriverDetailsModelFilter
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string HiddenId { get; set; }
        public int DriverId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DriverCode { get; set; }
        public string LaundryPlantName { get; set; }
        public int LaundryPlantId { get; set; }
        public string DriverName { get; set; }
        public string Status { get; set; }
        public string Statuss { get; set; }
        public string ICNo { get; set; }
        public DateTime EffectiveFrom { get; set; } = DateTime.Now;
        public DateTime EffectiveTo { get; set; } = DateTime.Now;
        public string ContactNo { get; set; }


        public int DriverDetId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public int LicenseTypeDetId { get; set; }
        public string LicenseNo { get; set; }
        public string ClassGrade { get; set; }
        public string IssuedBy { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }

        //==Child2 Table=======
        public List<LDriverDetailsLinenItemList> LDriverDetailsLinenItemGridList { get; set; }


        //=====================

        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class LDriverDetailsLinenItemList
    {
        public int DriverContactInfoId { get; set; }
        public int DriverId { get; set; }
        public int DriverDetId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public int LicenseTypeDetId { get; set; }
        public string LicenseNo { get; set; }
        public int ClassGrade { get; set; }
        public string ClassGrades { get; set; }
        public int IssuedBy { get; set; }
        public string IsssuedBy { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class DriverDetailsModelLovs
    {
        public List<LovValue> LaundryPlantId { get; set; }
        public List<LovValue> Status { get; set; }
        public List<LovValue> ClassGrade { get; set; }
        public List<LovValue> IssuedBy { get; set; }
        public List<LovValue> LaundryPlant { get; set; }

        public bool IsAdditionalFieldsExist { get; set; }

    }
}
