using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.FetchModels;

namespace CP.UETrack.Model.HWMS
{
    public class FacilitiesEquipment : FetchPagination
    {
        public int FetcId { get; set; }

        public int CustomerId { get; set; }

        public int FacilityId { get; set; }

        public string ItemCode { get; set; }

        public string ItemDescription { get; set; }

        public string ItemType { get; set; }

        public int Status { get; set; }

        public DateTime EffectiveFrom { get; set; }

        public DateTime? EffectiveTo { get; set; }

        public List<FacilitiesEquipment> AutoGenerate { get; set; }
    }
    public class FacilitiesEquipmentDropdown
    {
        public List<LovValue> FacilitiesStatusLovs { get; set; }
        public List<LovValue> ItemTypesLovs { get; set; }
    }
}
