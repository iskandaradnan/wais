using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class CleanLinenDespatchModel
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string GuId { get; set; }
        public int CleanLinenDespatchId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public int DespatchedFrom { get; set; }
        public DateTime DateReceived { get; set; }
        public int LaundryPlantID { get; set; }
        public string ReceivedBy { get; set; }
        public int ReceivedB { get; set; }
        public decimal NoOfPackages { get; set; }
        public decimal TotalWeightKg { get; set; }
        public int TotalReceivedPcs { get; set; }
        public string LaundryPlantName { get; set; }
        public string Remarks { get; set; }
        public int CleanLinenDespatchDetId { get; set; }
        public int LinenItemId { get; set; }
        public int DespatchedQuantity { get; set; }
        public string LinenCode { get; set; }
        public int ReceivedQuantity { get; set; }
        public int Variance { get; set; }
        public string LinenDescription { get; set; }
        public string StaffName { get; set; }
        public int AttachmentID { get; set; }
        public int FileType { get; set; }
        public string FileName { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public int UserRegistrationId { get; set; }

        //==Child2 Table=======
        public List<LUserCleanLinenItemList> LUserCleanLinenItemGridList { get; set; }


        //=====================
    }

    public class LUserCleanLinenItemList
    {
        public string Remarks { get; set; }
        public int CleanLinenDespatchDetId { get; set; }
        public int LinenItemId { get; set; }
        public int DespatchedQuantity { get; set; }
        public string LinenCode { get; set; }
        public int ReceivedQuantity { get; set; }
        public int Variance { get; set; }
        public string LinenDescription { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class CleanLinenDespatchModelLovs
    {
        public List<LovValue> FileType { get; set; }
        public List<LovValue> DespatchedFrom { get; set; }
                




    }
}