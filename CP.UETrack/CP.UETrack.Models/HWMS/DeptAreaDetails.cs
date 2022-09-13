using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using CP.UETrack.Model.Common;


namespace CP.UETrack.Model.HWMS
{
    public class DeptAreaDetails : FetchPagination
    {
       public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int DeptAreaId { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public DateTime? EffectiveFromDate { get; set; }
        public DateTime? EffectiveToDate { get; set; }
        public string OperatingDays { get; set; }
        public string Status { get; set; }
        public string Category { get; set; }
        public string Remarks { get; set; }
        
        public List<DeptAreaDetails> DeptAreaDetailsList { get; set; }
        public List<DeptAreaDetailsCollectionFrequency> DDCollectionList { get; set; }
        public List<DeptAreaConsumables> DDConsumablesList { get; set; }

        public List<Attachment> AttachmentList { get; set; }
        //public List<ItemTable> ItemCodeFetch { get; set; }
    }

        public class DeptAreaConsumables
    {
        public string ReceptaclesId { get; set; }
        public string WasteTypeConsumables { get; set; }
        public string ItemCode { get; set; }
        public string ItemName { get; set; }
        public string Size { get; set; }
        public string UOM { get; set; }
        public string ShelfLevelQuantity { get; set; }
        public bool isDeleted { get; set; }
    }
    public class DeptAreaDetailsCollectionFrequency
    {
        public string FrequencyId { get; set; }
        public string WasteTypeCollection { get; set; }
        public string FrequencyType { get; set; }
        public string CollectionFrequency { get; set; }
        public string StartTime1 { get; set; }       
        public string EndTime1 { get; set; }       
        public string StartTime2 { get; set; }
        public string EndTime2 { get; set; }
        public string StartTime3 { get; set; }
        public string EndTime3 { get; set; }
        public string StartTime4 { get; set; }
        public string EndTime4 { get; set; }
        public bool isDeleted { get; set; }

    }
    public class DeptAreaDetailsDropdownList
    {
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> CategoryLovs { get; set; }
        public List<LovValue> FrequencyTypeLovs { get; set; }
        public List<LovValue> CollectionFrequencyLovs { get; set; }
        public List<LovValue> OperatingDaysLovs { get; set; }
        public List<LovValue> WasteTypeLovs { get; set; }
        public List<LovValue> UOMLovs { get; set; }


    }
}