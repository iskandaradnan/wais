using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class soildLinencollectionsModel
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int SoiledLinenCollectionId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime CollectionDate { get; set; }
        public int LaundryPlantID { get; set; }
        public string LaundryPlantName { get; set; }
        public string Timestamp { get; set; }
        public DateTime DespatchDate { get; set; }
        public int SoiledLinenCollectionDetId { get; set; }
        public int LLSUserAreaId { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public Decimal Weight { get; set; }
        public int TotalWhiteBag { get; set; }
        public int TotalRedBag { get; set; }
        public int TotalGreenBag { get; set; }
        public int TotalBrownBag { get; set; }
        public int TotalSolidWeight { get; set; }
        public int CollectionSchedule { get; set; }
        public DateTime CollectionStartTime { get; set; }
        public DateTime CollectionEndTime { get; set; }
        public DateTime CollectionTime { get; set; }
        public int OnTime { get; set; }
        public int VerifiedBy { get; set; }
        public DateTime VerifiedDate { get; set; }
        public string Remarks { get; set; }
        public string Ownership { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public bool IsDeleted { get; set; }
        //==Child2 Table=======
        public List<LSoiledLinenItemGridListItem> LSoiledLinenItemGridList { get; set; }


        //=====================
        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserLocationCode { get; set; }
        public int UserRegistrationId { get; set; }
        public string StaffName { get; set; }

        public string GuId { get; set; }



    }
    public class soildLinencollectionsModel_Filter
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int SoiledLinenCollectionId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime CollectionDate { get; set; }
        public int LaundryPlantID { get; set; }
        public string LaundryPlantName { get; set; }
        public string Timestamp { get; set; }
        public DateTime DespatchDate { get; set; }
        public int SoiledLinenCollectionDetId { get; set; }
        public int LLSUserAreaId { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public Decimal Weight { get; set; }  
        public Decimal TotalWeight { get; set; }
        public int TotalWhiteBag { get; set; }
        public int TotalRedBag { get; set; }
        public int TotalGreenBag { get; set; }
        public int TotalBrownBag { get; set; }
        public Decimal TotalSolidWeight { get; set; }
        public int CollectionSchedule { get; set; }
        public DateTime CollectionStartTime { get; set; }
        public DateTime CollectionEndTime { get; set; }
        public DateTime CollectionTime { get; set; }
        public int OnTime { get; set; }
        public int VerifiedBy { get; set; }
        public DateTime VerifiedDate { get; set; }
        public string Remarks { get; set; }
        public string Ownership { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public bool IsDeleted { get; set; }
        //==Child2 Table=======
        public List<LSoiledLinenItemGridListItem_Filter> LSoiledLinenItemGridList { get; set; }


        //=====================
        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserLocationCode { get; set; }
        public int UserRegistrationId { get; set; }
        public string StaffName { get; set; }



    }
    public class LSoiledLinenItemGridListItem
    {
        public int LLSUserAreaId { get; set; }
        public int Verified { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public Decimal Weight { get; set; }
        public int TotalWhiteBag { get; set; }
        public String UserAreaCode { get; set; }
        public String UserLocationCode { get; set; }
        public int TotalRedBag { get; set; }
        public int TotalGreenBag { get; set; }
        public int TotalBrownBag { get; set; }
        public int TotalSolidWeight { get; set; }
        public int TotalQuantity { get; set; }
        public int CollectionSchedule { get; set; }
        public Nullable<System.TimeSpan> CollectionStartTime { get; set; }
        public Nullable<System.TimeSpan> CollectionEndTime { get; set; }
        public Nullable<System.TimeSpan> CollectionTime { get; set; }
        public String OnTime { get; set; }
        public DateTime EffectiveDate { get; set; }
        public String VerifiedBy { get; set; }
        public DateTime VerifiedDate { get; set; } = DateTime.Now;
        
        public string Remarks { get; set; }
        public string Ownership { get; set; }
        public int SoiledLinenCollectionDetId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class LSoiledLinenItemGridListItem_Filter
    {
        public Decimal TotalWeight { get; set; }
        public int LLSUserAreaId { get; set; }
        public int Verified { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public Decimal Weight { get; set; }
        public int TotalWhiteBag { get; set; }
        public String UserAreaCode { get; set; }
        public String UserLocationCode { get; set; }
        public int TotalRedBag { get; set; }
        public int TotalGreenBag { get; set; }
        public int TotalBrownBag { get; set; }
        public int TotalSolidWeight { get; set; }
        public int TotalQuantity { get; set; }
        public int CollectionSchedule { get; set; }
        public Nullable<System.TimeSpan> CollectionStartTime { get; set; }
        public Nullable<System.TimeSpan> CollectionEndTime { get; set; }
        public Nullable<System.TimeSpan> CollectionTime { get; set; }
        public String OnTime { get; set; }
        public DateTime EffectiveDate { get; set; }
        public String VerifiedBy { get; set; }
        public DateTime VerifiedDate { get; set; } = DateTime.Now;

        public string Remarks { get; set; }
        public string Ownership { get; set; }
        public int SoiledLinenCollectionDetId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class SoiledLinenCollectionModelLovs
    {
        public List<LovValue> Ownership { get; set; }
        public List<LovValue> CollectionSchedule { get; set; }
        public List<LovValue> OnTime { get; set; }
        public List<LovValue> LaundryPlant { get; set; }
        public bool IsAdditionalFieldsExist { get; set; }

    }
}