using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
   public class CentralLinenStoreHousekeepingModel
    { 
    public int HouseKeepingId { get; set; }
    public int CustomerID { get; set; }
    public int FacilityID { get; set; }
        public int StoreTypeId { get; set; }
        public string StoreType { get; set; }
    public string StoreTypes { get; set; }
    public string Year { get; set; }
    public int Years { get; set; }
    public string Month { get; set; }
    public string Timestamp { get; set; }



    public int HouseKeepingDetId { get; set; }
    public DateTime Date { get; set; }
    public int HousekeepingDone { get; set; }
    public DateTime DateTimeStamp { get; set; }
    


    public int CreatedBy { get; set; }
    public DateTime CreatedDate { get; set; }
    public DateTime CreatedDateUTC { get; set; }
    public int ModifiedBy { get; set; }
    public DateTime ModifiedDate { get; set; }
    public DateTime ModifiedDateUTC { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }

        public bool IsDeleted { get; set; }
        //==Child2 Table=======
        public List<LCentralHouseItemList> LCentralHouseItemGridList { get; set; }
        //=====================

        public string UserAreaCode { get; set; }
        public int LLSUserAreaId { get; set; }
        public int LLSUserAreaLocationId { get; set; }

        public string UserLocationCode { get; set; }
        public Nullable<System.TimeSpan> FirstScheduleStartTime { get; set; }
        public Nullable<System.TimeSpan> SecondScheduleEndTime { get; set; }

        
    }
    public class LCentralHouseItemList
    {
        public int HouseKeepingDetId { get; set; }
        public int HouseKeepingId { get; set; }
        public int StoreTypeId { get; set; }
        public DateTime? Date { get; set; }
        public int HousekeepingDone { get; set; }
        public DateTime EffectiveDate { get; set; }
        public DateTime DateTimeStamp { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class CentralLinenStoreHousekeepingModelLovs
    {
        public List<LovValue> MonthListTypedata { get; set; }
        public List<LovValue> StoreType { get; set; }
        public List<LovValue> Year { get; set; }
        public List<LovValue> MonthName { get; set; }
        public List<LovValue> HousekeepingDone { get; set; }
        public int CurrentYear { get; set; }

    }


    
}

