using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
   public class LinenRepairModel
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int LinenRepairId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime DocumentDate { get; set; }
        public string RepairedBy { get; set; }
        public string CheckedBy { get; set; }
        public string Remarks { get; set; }
      


        public int LinenRepairDetId { get; set; }
        public int LinenItemId { get; set; }
        public int RepairQuantity { get; set; }
        public int RepairCompletedQuantity { get; set; }
        public string DescriptionOfProblem { get; set; }
       

        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }

        //==Child2 Table=======
        public List<LLinenRepairItemList> LLinenRepairItemGridList { get; set; }


        //=====================

        public string LinenCode { get; set; }
        public string StaffName { get; set; }
        public string LinenDescription { get; set; }

        public int UserRegistrationId { get; set; }


    }

    public class LLinenRepairItemList
    {
       
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int LinenRepairDetId { get; set; }
        public int LinenItemId { get; set; }
        public Decimal RepairQuantity { get; set; }
        public Decimal RepairCompletedQuantity { get; set; }
        public string DescriptionOfProblem { get; set; }
        public Decimal BalanceRepairQuantity { get; set; }
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
