using System;
using System.Collections.Generic;
using CP.UETrack.Models;

namespace CP.UETrack.Model.BEMS
{
    public class MstLocationUserAreaViewModel
    {      
        public int UserAreaId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int BlockId { get; set; }
        public int LevelId { get; set; }
        public string UserLevelCode { get; set; }
        public string UserLevelName { get; set; }
        public string LevelName { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string HiddenId { get; set; }
        public string UserAreaDescription { get; set; }
        public int CompanyStaffId { get; set; }
        public string CompanyStaffName { get; set; }
        public int HospitalStaffId { get; set; }
        public string HospitalStaffName { get; set; }
         public string Remarks { get; set; }
        public System.DateTime ActiveFromDate { get; set; }
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
        public string StatusValue { get; set; }
        public string Status { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public bool  isStartDateFuture { get; set; }

        public int Category { get; set; }
    }

    public class AreaLovs
    {
        public int LevelId { get; set; }
        public int BlockId { get; set; }
        public int FacilityId { get; set; }
        public string LevelName { get; set; }
        public string LevelCode { get; set; }
        public string BlockName { get; set; }
        public string BlockCode { get; set; }

        //public List<CategoryValues> CategoryValue { get; set; }
    }


    //public class CategoryValues
    //{
    //    public List<LovValue> Category { get; set; }
       
    //}

}
