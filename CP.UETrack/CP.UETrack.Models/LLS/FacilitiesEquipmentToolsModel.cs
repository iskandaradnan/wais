using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
   public class FacilitiesEquipmentToolsModel
    {
        public int FETCId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string ItemType { get; set; }
        public int Status { get; set; }
        public int Statuss { get; set; }
        public DateTime EffectiveFromDate { get; set; } = DateTime.Now;
        public DateTime EffectiveToDate { get; set; } = DateTime.Now;
        public string EffectiveToDates { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class FacilitiesEquipmentToolsModelFilter
    {
        public int FETCId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string ItemType { get; set; }
        public string Status { get; set; }
        public int Statuss { get; set; }
        public DateTime EffectiveFromDate { get; set; } = DateTime.Now;
        public DateTime EffectiveToDate { get; set; } = DateTime.Now;
        public DateTime EffectiveToDates { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class FacilitiesEquipmentToolsModelLovs
    {
        public List<LovValue> ItemType { get; set; }
         public List<LovValue> Status { get; set; }

    }
}
