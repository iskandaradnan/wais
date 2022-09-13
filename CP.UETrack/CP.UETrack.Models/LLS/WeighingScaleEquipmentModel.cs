using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class WeighingScaleEquipmentModel
    {
        public int WeighingScaleId { get; set; }


        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string HiddenId { get; set; }
        public string GuId { get; set; }
        public string IssuedBy { get; set; }
        public string ItemDescription { get; set; }
        public string SerialNo { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public int Status { get; set; }
        
        // public string Status { get; set; }

        public string IsDeleted { get; set; }

        public int AttachmentId { get; set; }
        public string FileType { get; set; }
        public int FileName { get; set; }
       


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        
        //==Child2 Table=======
        public List<LweighingLinenItemList> LweighingLinenItemGridList { get; set; }


        //=====================

    }
    public class WeighingScaleEquipmentModelFilter
    {
        public int WeighingScaleId { get; set; }


        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string HiddenId { get; set; }
        public string GuId { get; set; }
        public string IssuedBy { get; set; }
        public string ItemDescription { get; set; }
        public string SerialNo { get; set; }
        public DateTime IssuedDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public string Status { get; set; }

        // public string Status { get; set; }

        public string IsDeleted { get; set; }

        public int AttachmentId { get; set; }
        public string FileType { get; set; }
        public int FileName { get; set; }



        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }

        //==Child2 Table=======
        public List<LweighingLinenItemList> LweighingLinenItemGridList { get; set; }


        //=====================

    }

    public class LweighingLinenItemList
    {
        public int WeighingScaleId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string IssuedBy { get; set; }
        public string ItemDescription { get; set; }
        public string SerialNo { get; set; }
        public DateTime IssuedDate { get; set; } = DateTime.Now;
        public DateTime ExpiryDate { get; set; } = DateTime.Now;
        public int GuId { get; set; }
        public string HiddenId { get; set; }
        public int Status { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class WeighingScaleEquipmentModelLovs
    {
        public List<LovValue> IssuedBy { get; set; }
        public List<LovValue> Status { get; set; }
        public List<LovValue> FileType { get; set; }

    }
}
