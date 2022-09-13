using System;

namespace CP.UETrack.Model.FetchModels
{
    public class FetchPagination
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
    public class LevelFetchModel : FetchPagination
    {

        public int LevelId { get; set; }
        public int BlockId { get; set; }
        public string LevelName { get; set; }
        public string LevelCode { get; set; }
    }


    public class CompanyStaffFetchModel : FetchPagination
    {
        public int StaffMasterId { get; set; }
        public string StaffEmployeeId { get; set; }
        public string StaffName { get; set; }
        public string FacilityName { get; set; }
        public string ContactNumber { get; set; }
        public string Designation { get; set; }
        public int? DesignationId { get; set; }
        public int Experience { get; set; }
        public string Email { get; set; }
    }
    public class FacilityStaffFetchModel : FetchPagination
    {
        public int StaffMasterId { get; set; }
        public string StaffEmployeeId { get; set; }
        public string StaffName { get; set; }
        public string FacilityName { get; set; }
        public string Designation { get; set; }

    }

    public class UserAreaFetch : FetchPagination
    {
        public int UserAreaId { get; set; }
        public string AssetCount { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int BlockId { get; set; }
        public int LevelId { get; set; }
        public int CompRepId { get; set; }
        public int FacRepId { get; set; }
        public string CompRep { get; set; }
        public string FacRep { get; set; }
        public string CompRepEmail { get; set; }
        public string FacRepEmail { get; set; }
        public DateTime ActiveFromDate { get; set; }
        public DateTime ActiveToDate { get; set; }

        public int FacilityId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        
        public string FacilityCode { get; set; }
        public string LinenCode { get; set; }
        public int LinenItemId { get; set; }
        public string LinenDescription { get; set; }
        public decimal AgreedShelfLevel { get; set; }

        public string StaffName { get; set; }
        public int LLSUserAreaId { get; set; }

        public int UserRegistrationId { get; set; }


    }


    public class BERAssetNoFetch : FetchPagination
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public string SupplierName { get; set; }
        public decimal? PurchaseCost { get; set; }
        public decimal? CurrentValue { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public decimal? AssetAge { get; set; }
        public int? StillwithInLifeSpan { get; set; }
    }
    public class AssetClassificationFetch : FetchPagination
    {
        public int AssetClassificationId { get; set; }
        public string AssetClassificationCode { get; set; }
        public string AssetClassificationDescription { get; set; }
        public int TypeOfServices { get; set; }
    }


    public class ItemCodeFetch : FetchPagination
    {
        public int ItemId { get; set; }
        public string ItemNo { get; set; }
        public string ItemDescription { get; set; }
    }
    public class BERRejectedNoFetch : FetchPagination
    {
        public int RejectedApplicationId { get; set; }
        public string BERno { get; set; }
        public string BERStatusName { get; set; }
        public int BERStatusLovId { get; set; }
        public int BERStage { get; set; }
    }

    public class BERNoList : FetchPagination
    {
        public int RejectedApplicationId { get; set; }
        public string BERno { get; set; }
        public string BERStatusName { get; set; }
        public int BERStatusLovId { get; set; }
        public int BERStage { get; set; }
    }

    public class CustomerFetch : FetchPagination
    {
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; }
    }

    public class PortAssetFetchModel : FetchPagination
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int BlockId { get; set; }
        public int LevelId { get; set; }
        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public int BERStage { get; set; }
        public string MaintenanceWorkNo { get; set; }
        public int WorkOrderId { get; set; }
        public string CustomerName { get; set; }
        public string FacilityName { get; set; }
        public string BlockName { get; set; }
        public string LevelName { get; set; }
        public string UserAreaName { get; set; }
        public string UserLocationName { get; set; }
        public DateTime? BookingStartDate { get; set; }
        public DateTime? BookingEndDate { get; set; }
        public bool IsLoaner { get; set; }
        public string Model { get; set; }
        public string Manufacture { get; set; }
    }
    public class BookingFetch : FetchPagination
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }    
        public string MaintenanceWorkNo { get; set; }
        public int WorkOrderId { get; set; }
        public DateTime? BookingStartDate { get; set; }
        public DateTime? BookingEndDate { get; set; }
        public int? TypeOfAsset { get; set; }
        public string AssetTypeDescription { get; set; }
        public string AssetTypeCode { get; set; }
        public string NumberofDays { get; set; }
        public int CompanyRepId { get; set; }
        public string CompanyRepEmail { get; set; }
        public string Model { get; set; }
        public string Manufacturer { get; set; }
        public DateTime? CalibrationdueDate { get; set; }
    }

    public class AreaFetch : FetchPagination
    {
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string FacilityCode { get; set; }
        public int BlockId { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
       

        public int LevelId { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }

        public int UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }

        public int QualityCauseId { get; set; }
        public string Description { get; set; }
        public string CauseCode { get; set; }
    }

    public class ModelSearching : FetchPagination
    {
        public int ModelId { get; set; }
        public string Model { get; set; }
        public int TypeCodeId { get; set; }
        public int? ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public string ScreenName { get; set; }

        //public int PageIndex { get; set; }
        //public int TotalRecords { get; set; }
        //public int FirstRecord { get; set; }
        //public int LastRecord { get; set; }
        //public int LastPageIndex { get; set; }

        public int TypeOfServices { get; set; }

        #region LLS Fetch and Search

        public class DepartmentFetch : FetchPagination
        {
            public int FacilityId { get; set; }
            public string FacilityName { get; set; }
            public string FacilityCode { get; set; }
            public int BlockId { get; set; }
            public string BlockCode { get; set; }
            public string BlockName { get; set; }


            public int LevelId { get; set; }
            public string LevelCode { get; set; }
            public string LevelName { get; set; }

            public int UserAreaId { get; set; }
            public string UserAreaCode { get; set; }
            public string UserAreaName { get; set; }

           
        }

        public class LinenItemCodeFetch : FetchPagination
        {
            public int FacilityId { get; set; }
            public string FacilityName { get; set; }
            public string FacilityCode { get; set; }
            public string LinenCode { get; set; }
            public int LinenItemId { get; set; }
            public string LinenDescription { get; set; }
          
        }

        public class LocationCodeFetch : FetchPagination
        {
            public int UserAreaId { get; set; }
            public int UserLocationId { get; set; }
        public int FacilityId { get; set; }
            
            public string UserLocationName { get; set; }
            public string UserLocationCode { get; set; }
           
            
            public string FacilityCode { get; set; }
            public string LinenCode { get; set; }
            public int LinenItemId { get; set; }
            public string LinenDescription { get; set; }

            public string UserAreaCode { get; set; }

            public string AgreedShelfLevel { get; set; }

            public int LLSUserAreaLocationId { get; set; }
            public int LLSUserAreaId { get; set; }
            public string  StoreBalance { get; set; }

        }



        #endregion

    }
}




