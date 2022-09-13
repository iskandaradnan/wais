using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.KPI
{
    public class PenaltyMasterModel
    {
        public int PenaltyId { get; set; }
        public string PenaltyDescription { get; set; }
        public int ServiceId { get; set; }
        public int CriteriaId { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public List<ItemPenaltyMasterList> PenaltyListData { get; set; }
    }

    public class PenaltyTypeDropdown
    {
        public List<LovValue> PenaltyServiceTypeData { get; set; }
        public List<LovValue> PenaltyCriteriaTypeData { get; set; }
        public List<LovValue> PenaltyStatusTypeData { get; set; }
    }
    public class ItemPenaltyMasterList
    {
        public int PenaltyDetId { get; set; }
        public int ServiceId { get; set; }
        public int PenaltyId { get; set; }
        public int CriteriaId { get; set; }
        public int Status { get; set; }
        public string PenaltyDescription { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
    }
}
