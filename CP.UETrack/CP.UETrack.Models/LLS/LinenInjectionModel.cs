using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class LinenInjectionModel
    {
        public int LinenInjectionId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime InjectionDate { get; set; }
        public string Remarks { get; set; }
        public string PONo { get; set; }
        public int DOId { get; set; }
        public string GuId { get; set; }

        public string Timestamp { get; set; }

        public int LinenInjectionDetId { get; set; }
        public int LinenItemId { get; set; }
        public int QuantityInjected { get; set; }
        public string DONo { get; set; }
        public DateTime DODate { get; set; }
        public string TestReport { get; set; }
        public DateTime LifeSpanValidity { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }

        public bool IsDeleted { get; set; }
        public string DONO { get; set; }
        public DateTime DODates { get; set; }
        public string PONos { get; set; }

        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }

        //==Child2 Table=======
        public List<LLinenInjectionLinenItemList> LLinenInjectionLinenItemListGrid { get; set; }

        //=====================

    }

    public class LLinenInjectionLinenItemList
    {
        public Decimal LinenPrice { get; set; }
        public int LinenInjectionDetId { get; set; }
        public int LinenInjectionId { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int QuantityInjected { get; set; }
        public int LinenItemId { get; set; }
        public string DONo { get; set; }
        //public string Guid { get; set; }
        public DateTime DODate { get; set; }
        public string TestReport { get; set; }
        public DateTime LifeSpanValidity { get; set; }

        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
}
