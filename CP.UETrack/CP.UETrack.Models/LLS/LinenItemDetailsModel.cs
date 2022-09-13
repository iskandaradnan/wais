using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
   public class LinenItemDetailsModel
    {
        public int LinenItemId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public string UOM { get; set; }
        public int LinenCategory { get; set; }
        public string Status { get; set; }
        public string Material { get; set; }
        public string Color { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string Size { get; set; }
        public string Colour { get; set; }
        public string IdentificationMark { get; set; }
        public string Standard { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }

        public string LinenPrice { get; set; }
    }
    public class LinenItemDetailsModelLovs
    {
        public List<LovValue> UOM { get; set; }
        public List<LovValue> LinenCategory  { get; set; }
        public List<LovValue> Status { get; set; }
        public List<LovValue> Material { get; set; }
        public List<LovValue> Colour { get; set; }
        public List<LovValue> Standard { get; set; }

    }
}
