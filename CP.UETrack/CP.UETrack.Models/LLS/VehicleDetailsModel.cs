using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
   public class VehicleDetailsModel
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int VehicleId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string VehicleNo { get; set; }
        public string Model { get; set; }
        public int Manufacturer { get; set; }
        public int LaundryPlantId { get; set; }
        public string LaundryPlantName { get; set; }
        public int Status { get; set; }
        public DateTime EffectiveFrom { get; set; } = DateTime.Now;
        public DateTime EffectiveTo { get; set; } = DateTime.Now;
        public int LoadWeight { get; set; }
       

        public int VehicleDetId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public int LicenseTypeDetId { get; set; }
        public string LicenseNo { get; set; }
        public int ClassGrade { get; set; }
        public string IssuedBy { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }
       


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public String Timestamp { get; set; }
        public bool IsDeleted { get; set; }

        //==Child2 Table=======
        public List<LVehicleLinenItemList> LVehicleDetailsLinenItemGridList { get; set; }


        //=====================
    }

    public class VehicleDetailsModelFilter
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int VehicleId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string VehicleNo { get; set; }
        public string Model { get; set; }
        public string Manufacturer { get; set; }
        public int LaundryPlantId { get; set; }
        public string LaundryPlantName { get; set; }
        public string Status { get; set; }
        public DateTime EffectiveFrom { get; set; } = DateTime.Now;
        public DateTime EffectiveTo { get; set; } = DateTime.Now;
        public int LoadWeight { get; set; }


        public int VehicleDetId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public int LicenseTypeDetId { get; set; }
        public string LicenseNo { get; set; }
        public int ClassGrade { get; set; }
        public string IssuedBy { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }



        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public String Timestamp { get; set; }
        public bool IsDeleted { get; set; }

        //==Child2 Table=======
        public List<LVehicleLinenItemList> LVehicleDetailsLinenItemGridList { get; set; }


        //=====================
    }



    public class LVehicleLinenItemList
    {
        public int VehicleDetId { get; set; }
        public string LicenseCode { get; set; }
        public string LicenseDescription { get; set; }
        public int LicenseTypeDetId { get; set; }
        public string LicenseNo { get; set; }
        public string ClassGrades { get; set; }
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
    public class VehicleDetailsModelLovs
    {
        public List<LovValue> Manufacturer { get; set; }
        public List<LovValue> LaundryPlantName { get; set; }
        public List<LovValue> Status { get; set; }
        public List<LovValue> ClassGrade { get; set; }
        public List<LovValue> IssuedBy { get; set; }

        public bool IsAdditionalFieldsExist { get; set; }
    }
}
